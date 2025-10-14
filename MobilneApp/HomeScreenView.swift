// HomeScreenView.swift
// MobilneApp
//
// Created by Dajana Isaku on 11. 10. 2025..

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct WarrantyItem: Identifiable {
    var id: String = UUID().uuidString
    let productName: String
    let purchaseDate: String
    let warrantyPeriod: String
    let category: String
    let cost: String
    var localImagePath: String? = nil
    
    
}

struct HomeScreenView: View {
    @State private var searchText = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var warranties: [WarrantyItem] = []
    
    let topColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    var filteredWarranties: [WarrantyItem] {
        if searchText.isEmpty {
            return warranties
        } else {
            return warranties.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [topColor, bottomColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: logoutUser) {
                            Label("Logout", systemImage: "arrow.right.circle.fill")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.black.opacity(0.25))
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                        TextField("Search...", text: $searchText)
                            .padding(8)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 3)
                    .padding(.bottom, 8)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            if filteredWarranties.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("No devices found")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                            } else {
                                ForEach(filteredWarranties) { warranty in
                                    NavigationLink(destination: EditWarrantyView(warranty: warranty)) {
                                        WarrantyCellView(
                                            productName: warranty.productName,
                                            purchaseDate: warranty.purchaseDate,
                                            warrantyPeriod: warranty.warrantyPeriod,
                                            category: warranty.category,
                                            localImagePath: warranty.localImagePath
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Text("Home")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Spacer()
                        NavigationLink(destination: ProfileScreenView()) {
                            VStack {
                                Image(systemName: "person")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.system(size: 24))
                                Text("Profile")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateWarrantyView()) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding()
                                .background(Color(red: 80/255, green: 90/255, blue: 90/255))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 90)
                    }
                }
            }
        }
        .onAppear {
            fetchWarranties()
        }
    }
    
    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func fetchWarranties() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No logged-in user")
            return
        }

        let db = Firestore.firestore()
        db.collection("warranties")
            .whereField("userId", isEqualTo: userId) 
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching warranties: \(error)")
                    return
                }
                if let documents = snapshot?.documents {
                    self.warranties = documents.map { doc in
                        let data = doc.data()
                        return WarrantyItem(
                            id: doc.documentID,
                            productName: data["productName"] as? String ?? "",
                            purchaseDate: data["purchaseDate"] as? String ?? "",
                            warrantyPeriod: data["warrantyPeriod"] as? String ?? "",
                            category: data["category"] as? String ?? "",
                            cost: data["cost"] as? String ?? ""
                        )
                    }
                }
            }
    }

}

#Preview {
    HomeScreenView()
}
