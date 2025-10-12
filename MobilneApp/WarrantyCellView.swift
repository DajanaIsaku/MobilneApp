//
//  WarrantyCellView.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 12. 10. 2025..
//

import SwiftUI

struct WarrantyCellView: View {
    var productName: String
    var purchaseDate: String
    var warrantyPeriod: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "doc.text.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.gray.opacity(0.9))

            VStack(alignment: .leading, spacing: 6) {
                Text(productName)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Purchased: \(purchaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Warranty: \(warrantyPeriod)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 162/255, green: 230/255, blue: 218/255),
                Color(red: 42/255, green: 43/255, blue: 43/255)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            WarrantyCellView(productName: "MacBook Air", purchaseDate: "10/10/2024", warrantyPeriod: "2 years")
            WarrantyCellView(productName: "iPhone 14", purchaseDate: "05/06/2023", warrantyPeriod: "1 year")
        }
    }
}

