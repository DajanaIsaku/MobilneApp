// CreateWarrantyView.swift
// MobilneApp
//
// Created by Dajana Isaku on 12. 10. 2025.

import SwiftUI
import FirebaseFirestore
import UIKit

struct CreateWarrantyView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var purchaseDate: Date = Date()
    @State private var warrantyLength: String = ""
    @State private var category: String = ""
    @State private var cost: String = ""
    @State private var selectedCurrency: Int = 0
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isCameraSelected = false
    @State private var showSourceSelection = false
    
    let borderRadius: CGFloat = 8
    let sideMargin: CGFloat = 24
    
    let topGradientColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomGradientColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    let currencies = ["USD", "EUR"]
    let categories = ["Laptop", "Smartphone", "Smartwatch", "TV", "Headphones"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(borderRadius)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(height: 200)
                            .cornerRadius(borderRadius)
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, sideMargin)
                .onTapGesture {
                    showSourceSelection = true
                }
                .confirmationDialog("Select Source", isPresented: $showSourceSelection) {
                    Button("Camera") {
                        isCameraSelected = true
                        isShowingImagePicker = true
                    }
                    Button("Photo Library") {
                        isCameraSelected = false
                        isShowingImagePicker = true
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
                Divider()
                    .background(Color.white.opacity(0.16))
                    .padding(.horizontal, sideMargin)
                
                VStack(spacing: 12) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name*").foregroundColor(.white)
                        TextField("Enter Name", text: $name)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Date*").foregroundColor(.white)
                        DatePicker("Select Date", selection: $purchaseDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Warranty Length (months)*").foregroundColor(.white)
                        TextField("Enter Length", text: $warrantyLength)
                            .keyboardType(.numberPad)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Category*").foregroundColor(.white)
                        Picker("Select Category", selection: $category) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat).tag(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(borderRadius)
                        .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cost*").foregroundColor(.white)
                        HStack {
                            TextField("Enter cost", text: $cost)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(borderRadius)
                                .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                            Picker("", selection: $selectedCurrency) {
                                ForEach(0..<currencies.count, id: \.self) { index in
                                    Text(currencies[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 100)
                        }
                    }
                }
                .padding(.horizontal, sideMargin)
                
                HStack(spacing: 16) {
                    Button(action: saveWarranty) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                    }
                    
                    Button(action: discardForm) {
                        Text("Discard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                    }
                }
                .padding(.horizontal, sideMargin)
                .padding(.bottom, 30)
                
            }
            .padding(.top, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [topGradientColor, bottomGradientColor]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Create Warranty")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveWarranty() {
        guard !name.isEmpty,
              !warrantyLength.isEmpty,
              !category.isEmpty,
              !cost.isEmpty else {
            print("Please fill all fields")
            return
        }
        
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: purchaseDate)
        
        let warrantyData: [String: Any] = [
            "productName": name,
            "purchaseDate": dateString,
            "warrantyPeriod": warrantyLength + " months",
            "category": category,
            "cost": cost + " " + currencies[selectedCurrency],
            "timestamp": Timestamp()
        ]
        
        db.collection("warranties").addDocument(data: warrantyData) { error in
            if let error = error {
                print("Error saving warranty: \(error.localizedDescription)")
            } else {
                print("Warranty saved successfully")
                dismiss()
            }
        }
    }
    
    private func discardForm() {
        name = ""
        warrantyLength = ""
        category = ""
        cost = ""
        selectedCurrency = 0
        selectedImage = nil
    }
}

#Preview {
    CreateWarrantyView()
}
