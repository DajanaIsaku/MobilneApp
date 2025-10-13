//
//  ProfileScreenView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 12. 10. 2025..
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct ProfileScreenView: View {
    @State private var userEmail: String = "Unknown User"
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil

    let topColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomColor = Color(red: 42/255, green: 43/255, blue: 43/255)

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [topColor, bottomColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer(minLength: 80)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .overlay(
                                Circle().stroke(Color.white.opacity(0.8), lineWidth: 3)
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(radius: 5)
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Choose Profile Photo")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .underline()
                    }
                    .onChange(of: selectedItem) { newItem in
                        if let newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }

                    Text(userEmail)
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 30)

                    Text("My Warranties")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.bottom, 100)

                    Spacer()

                    HStack {
                        Spacer()
                        NavigationLink(destination: HomeScreenView()) {
                            VStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.system(size: 24))
                                Text("Home")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        VStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Text("Profile")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    userEmail = user.email ?? "No email found"
                } else {
                    userEmail = "Not logged in"
                }
            }
        }
    }
}

#Preview {
    ProfileScreenView()
}
