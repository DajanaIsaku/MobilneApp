//  CreateWarrantyView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 12. 10. 2025.
//

import SwiftUI
import PhotosUI
import UIKit

struct CreateWarrantyView: View {
    @State private var name: String = ""
    @State private var purchaseDate: String = ""
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
    let placeholderColor = Color.gray
    
    let topGradientColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomGradientColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    let currencies = ["USD", "EUR"]
    
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
                        Text("Name*")
                            .foregroundColor(.white)
                        TextField("Enter Name", text: $name)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: borderRadius)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Date*")
                            .foregroundColor(.white)
                        TextField("Enter Date", text: $purchaseDate)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: borderRadius)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Warranty Length*")
                            .foregroundColor(.white)
                        TextField("Enter Length (months)", text: $warrantyLength)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: borderRadius)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Category*")
                            .foregroundColor(.white)
                        Button(action: {
                            print("Select category tapped")
                        }) {
                            HStack {
                                Text(category.isEmpty ? "Select category" : category)
                                    .foregroundColor(category.isEmpty ? placeholderColor : .white)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(borderRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: borderRadius)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cost*")
                            .foregroundColor(.white)
                        HStack {
                            TextField("Enter cost", text: $cost)
                                .keyboardType(.decimalPad)
                                .padding(10)
                                .background(Color.black.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(borderRadius)
                                .overlay(
                                    RoundedRectangle(cornerRadius: borderRadius)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                            Picker("", selection: $selectedCurrency) {
                                ForEach(0..<currencies.count, id: \.self) { index in
                                    Text(currencies[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 100)
                        }
                    }
                    
                    Text("All fields are required")
                        .foregroundColor(.red)
                        .opacity(0)
                }
                .padding(.horizontal, sideMargin)
                
                HStack(spacing: 16) {
                    Button(action: {
                        print("Save tapped")
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                    }
                    
                    Button(action: {
                        print("Discard tapped")
                    }) {
                        Text("Discard")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.6))
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
}

#Preview {
    CreateWarrantyView()
}
