//  ProfileScreenView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 12. 10. 2025..
//

import SwiftUI

struct ProfileScreenView: View {

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

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 5)

                    Text("user@gmail.com")
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
        }
    }
}

#Preview {
    ProfileScreenView()
}
