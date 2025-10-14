import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import UIKit
import CoreLocation
import MapKit

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
    @State private var isSaving = false
    
    @State private var showMapPicker = false
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var locationName: String = ""
    
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
                .onTapGesture { showSourceSelection = true }
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
                    inputField(title: "Name*", text: $name, placeholder: "Enter Name")
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Date*").foregroundColor(.white)
                        DatePicker("Select Date", selection: $purchaseDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.black.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                            .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
                    }
                    
                    inputField(title: "Warranty Length (months)*", text: $warrantyLength, placeholder: "Enter Length", isNumber: true)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Category*").foregroundColor(.white)
                        Picker("Select Category", selection: $category) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat).tag(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
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
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Purchase Location").foregroundColor(.white)
                        
                        Button(action: { showMapPicker = true }) {
                            Text("Select on Map")
                                .frame(maxWidth: .infinity)
                                .padding(10)
                                .background(Color.gray.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(borderRadius)
                        }
                        
                        if !locationName.isEmpty {
                            Text("Selected: \(locationName)")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.top, 4)
                        }
                    }
                    .sheet(isPresented: $showMapPicker) {
                        MapPickerView(selectedCoordinate: $selectedCoordinate, locationName: $locationName)
                    }
                }
                .padding(.horizontal, sideMargin)
                
                if isSaving {
                    ProgressView("Saving...")
                        .foregroundColor(.white)
                        .padding()
                }
                
                HStack(spacing: 16) {
                    Button(action: saveWarranty) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(borderRadius)
                    }
                    .disabled(isSaving)
                    
                    
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
    
    private func inputField(title: String, text: Binding<String>, placeholder: String, isNumber: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).foregroundColor(.white)
            TextField(placeholder, text: text)
                .keyboardType(isNumber ? .numberPad : .default)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(borderRadius)
                .overlay(RoundedRectangle(cornerRadius: borderRadius).stroke(Color.white, lineWidth: 1))
        }
    }
    
    private func discardForm() {
        name = ""
        warrantyLength = ""
        category = ""
        cost = ""
        selectedCurrency = 0
        selectedImage = nil
        selectedCoordinate = nil
        locationName = ""
    }
    
    private func saveWarranty() {
        guard !name.isEmpty, !warrantyLength.isEmpty, !category.isEmpty, !cost.isEmpty else {
            print("Please fill all fields")
            return
        }
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        isSaving = true
        
        var localImagePath: String? = nil
        if let image = selectedImage, let data = image.jpegData(compressionQuality: 0.7) {
            let filename = UUID().uuidString + ".jpg"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            do {
                try data.write(to: url)
                localImagePath = filename
            } catch {
                print("Failed to save image: \(error.localizedDescription)")
            }
        }
        
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: purchaseDate)
        
        var warrantyData: [String: Any] = [
            "userId": userId,
            "productName": name,
            "purchaseDate": dateString,
            "warrantyPeriod": warrantyLength + " months",
            "category": category,
            "cost": cost + " " + currencies[selectedCurrency],
            "timestamp": Timestamp()
        ]
        
        if let localPath = localImagePath {
            warrantyData["localImagePath"] = localPath
        }
        if let coord = selectedCoordinate {
            warrantyData["purchaseLocation"] = [
                "latitude": coord.latitude,
                "longitude": coord.longitude,
                "name": locationName
            ]
        }
        
        db.collection("warranties").addDocument(data: warrantyData) { error in
            isSaving = false
            if let error = error {
                print("Error saving warranty: \(error.localizedDescription)")
            } else {
                print("Warranty saved successfully!")
                dismiss()
            }
        }
    }
}
