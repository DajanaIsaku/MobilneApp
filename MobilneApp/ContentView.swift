//
//  ContentView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 11. 10. 2025..
//

import SwiftUI
import FirebaseAuth

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                HomeScreenView()
            } else {
                LoginView()
            }
        }
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false

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
                Text("Welcome")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("Log in to your account")
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

                Button(action: {
                    loginUser()
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2A2B2B"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#A2E6DA"))
                        .cornerRadius(14)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Login Info"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }

                HStack {
                    Text("Don’t have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    NavigationLink(destination: RegistrationView()) {
                        Text("Sign up")
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

    private func loginUser() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    alertMessage = "Login failed: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    print("User logged in: \(result?.user.email ?? "")")
                    isLoggedIn = true 
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
