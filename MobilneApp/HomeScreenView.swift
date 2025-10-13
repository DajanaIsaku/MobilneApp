//  HomeScreenView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 11. 10. 2025..
//

import SwiftUI
import FirebaseAuth

struct WarrantyItem: Identifiable {
    let id = UUID()
    let productName: String
    let purchaseDate: String
    let warrantyPeriod: String
}


struct HomeScreenView: View {
    @State private var searchText = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    let topColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    let warranties = [
           WarrantyItem(productName: "MacBook Air", purchaseDate: "10/10/2024", warrantyPeriod: "2 years"),
           WarrantyItem(productName: "iPhone 14", purchaseDate: "05/06/2023", warrantyPeriod: "1 year"),
           WarrantyItem(productName: "Apple Watch", purchaseDate: "22/01/2023", warrantyPeriod: "1 year"),
           WarrantyItem(productName: "Samsung TV", purchaseDate: "15/05/2022", warrantyPeriod: "3 years"),
           WarrantyItem(productName: "Sony Headphones", purchaseDate: "30/09/2024", warrantyPeriod: "2 years")
       ]
    
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
                                            .padding(.top, 0)
                                            .padding(.trailing, 20)
                                        }
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search...", text: $searchText)
                            .padding(8)
                            .background(Color.white.opacity(0.2))
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 50)
                            } else {
                                ForEach(filteredWarranties) { warranty in
                                    WarrantyCellView(
                                        productName: warranty.productName,
                                        purchaseDate: warranty.purchaseDate,
                                        warrantyPeriod: warranty.warrantyPeriod
                                    )
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
                            VStack{
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                    .padding()
                                    .background(Color(red: 80/255, green: 90/255, blue: 90/255))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            }
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 90)
                    }
                }
                
            }
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
   }

        
#Preview {
    HomeScreenView()
}
    
