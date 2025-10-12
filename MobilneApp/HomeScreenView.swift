//  HomeScreenView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 11. 10. 2025..
//

import SwiftUI

struct HomeScreenView: View {
    @State private var searchText = ""
    
    let topColor = Color(red: 162/255, green: 230/255, blue: 218/255)
    let bottomColor = Color(red: 42/255, green: 43/255, blue: 43/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [topColor, bottomColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
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
                    .padding(.top, 50)
                    
                    ScrollView {
                                           VStack(spacing: 16) {
                                               WarrantyCellView(productName: "MacBook Air", purchaseDate: "10/10/2024", warrantyPeriod: "2 years")
                                               WarrantyCellView(productName: "iPhone 14", purchaseDate: "05/06/2023", warrantyPeriod: "1 year")
                                               WarrantyCellView(productName: "Apple Watch", purchaseDate: "22/01/2023", warrantyPeriod: "1 year")
                                               WarrantyCellView(productName: "Samsung TV", purchaseDate: "15/05/2022", warrantyPeriod: "3 years")
                                               WarrantyCellView(productName: "Sony Headphones", purchaseDate: "30/09/2024", warrantyPeriod: "2 years")
                                           }
                                           .padding(.top, 20)
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
            
}
        
#Preview {
    HomeScreenView()
}
    
