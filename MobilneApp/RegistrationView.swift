//  RegistrationView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 11. 10. 2025..
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#A2E6DA"),
                    Color(hex: "#2A2B2B")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("Sign Up")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("Create your account")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.subheadline)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Enter your email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)

                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.white.opacity(0.7))
                        if isSecure {
                            SecureField("Enter your password", text: $password)
                                .foregroundColor(.white)
                        } else {
                            TextField("Enter your password", text: $password)
                                .foregroundColor(.white)
                        }

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)

                    HStack {
                        Image(systemName: "lock.rotation")
                            .foregroundColor(.white.opacity(0.7))
                        if isSecure {
                            SecureField("Confirm your password", text: $confirmPassword)
                                .foregroundColor(.white)
                        } else {
                            TextField("Confirm your password", text: $confirmPassword)
                                .foregroundColor(.white)
                        }

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }

                Button(action: {
                    if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        alertMessage = "Please fill in all fields."
                        showAlert = true
                    } else if password != confirmPassword {
                        alertMessage = "Passwords do not match."
                        showAlert = true
                    } else {
                        print("Signup success")
                    }
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2A2B2B"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#A2E6DA"))
                        .cornerRadius(14)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }

                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    NavigationLink(destination: ContentView()) {
                        Text("Log in")
                            .foregroundColor(Color(hex: "#A2E6DA"))
                            .bold()
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 100)
        }
    }
}
