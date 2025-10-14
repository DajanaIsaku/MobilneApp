//
//  EditWarrantyView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 13. 10. 2025.
//

import SwiftUI
import FirebaseFirestore
import UIKit

struct EditWarrantyView: View {
    @Environment(\.dismiss) var dismiss
    var warranty: WarrantyItem

    @State private var name: String
    @State private var purchaseDate: Date
    @State private var warrantyLength: String
    @State private var category: String
    @State private var cost: String
    //@State private var purchaseLocation: String
    @State private var selectedCurrency: Int = 0
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isCameraSelected = false
    @State private var showSourceSelection = false

    let currencies = ["USD", "EUR"]
    let categories = ["Laptop", "Smartphone", "Smartwatch", "TV", "Headphones"]
    let borderRadius: CGFloat = 8
    let sideMargin: CGFloat = 24

    init(warranty: WarrantyItem) {
        self.warranty = warranty
        _name = State(initialValue: warranty.productName)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        _purchaseDate = State(initialValue: formatter.date(from: warranty.purchaseDate) ?? Date())

        _warrantyLength = State(initialValue: warranty.warrantyPeriod.replacingOccurrences(of: " months", with: ""))
        _category = State(initialValue: warranty.category)

        let components = warranty.cost.split(separator: " ")
        if components.count == 2 {
            _cost = State(initialValue: String(components[0]))
            if let index = currencies.firstIndex(of: String(components[1])) {
                _selectedCurrency = State(initialValue: index)
            }
        } else {
            _cost = State(initialValue: warranty.cost)
        }

        //_purchaseLocation = State(initialValue: warranty.purchaseLocation)
    }

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
                .onTapGesture { showSourceSelection = true }
                .confirmationDialog("Select Source", isPresented: $showSourceSelection) {
                    Button("Camera") { isCameraSelected = true; isShowingImagePicker = true }
                    Button("Photo Library") { isCameraSelected = false; isShowingImagePicker = true }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .onAppear { loadWarrantyImage() }

                Divider()
                    .background(Color.white.opacity(0.16))
                    .padding(.horizontal, sideMargin)

                VStack(spacing: 12) {
                    CustomInputField(title: "Name*", text: $name)
                    VStack(alignment: .leading, spacing: 4) {
                                            Text("Purchase Date*").foregroundColor(.white)
                                            Text(purchaseDateFormatted)
                                                .padding(10)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.black.opacity(0.3))
                                                .foregroundColor(.white)
                                                .cornerRadius(borderRadius)
                                                .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    };                    CustomInputField(title: "Warranty Length (months)*", text: $warrantyLength, keyboardType: .numberPad)

                    VStack(alignment: .leading, spacing: 4) {
                                           Text("Category*").foregroundColor(.white)
                                           Text(category)
                                               .padding(10)
                                               .frame(maxWidth: .infinity)
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

                    //CustomInputField(title: "Location*", text: $purchaseLocation)
                }
                .padding(.horizontal, sideMargin)

                HStack(spacing: 16) {
                    Button(action: updateWarranty) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                    }

                    Button(action: deleteWarranty) {
                        Image(systemName: "trash.fill")
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
                gradient: Gradient(colors: [
                    Color(red: 162/255, green: 230/255, blue: 218/255),
                    Color(red: 42/255, green: 43/255, blue: 43/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("Edit Warranty")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - LOAD IMAGE
    private func loadWarrantyImage() {
        guard selectedImage == nil, let localPath = warranty.localImagePath else { return }
        let fileURL = getDocumentsDirectory().appendingPathComponent(localPath)
        if FileManager.default.fileExists(atPath: fileURL.path),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            selectedImage = image
        }
    }

    private func updateWarranty() {
        guard !name.isEmpty, !warrantyLength.isEmpty, !category.isEmpty, !cost.isEmpty else {
            print("Please fill all fields")
            return
        }

        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: purchaseDate)

        var updatedData: [String: Any] = [
            "productName": name,
            "purchaseDate": dateString,
            "warrantyPeriod": warrantyLength + " months",
            "category": category,
            "cost": cost + " " + currencies[selectedCurrency],
            "timestamp": Timestamp()
            //"purchaseLocation.name": purchaseLocation
        ]

        if let image = selectedImage,
           let data = image.jpegData(compressionQuality: 0.7) {
            let filename = "\(UUID().uuidString).jpg"
            let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
            try? data.write(to: fileURL)
            updatedData["localImagePath"] = filename
        }

        db.collection("warranties").document(warranty.id).updateData(updatedData) { error in
            if let error = error {
                print("Error updating warranty: \(error.localizedDescription)")
            } else {
                print("Warranty updated successfully")
                dismiss()
            }
        }
    }

    // MARK: - DELETE WARRANTY
    private func deleteWarranty() {
        let db = Firestore.firestore()
        db.collection("warranties").document(warranty.id).delete { error in
            if let error = error {
                print("Error deleting warranty: \(error.localizedDescription)")
            } else {
                print("Warranty deleted successfully")
                dismiss()
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var purchaseDateFormatted: String {
            let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy."
            return formatter.string(from: purchaseDate)
        }
}


struct CustomInputField: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    let borderRadius: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).foregroundColor(.white)
            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(borderRadius)
                .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
        }
    }
}

struct DateInputField: View {
    var title: String
    @Binding var date: Date
    let borderRadius: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).foregroundColor(.white)
            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(borderRadius)
                .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
        }
    }
}
