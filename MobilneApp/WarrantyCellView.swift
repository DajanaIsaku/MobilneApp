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
    var category: String
    let localImagePath: String?

    private func iconName(for category: String) -> String {
        switch category.lowercased() {
        case "laptop":
            return "laptopcomputer"
        case "smartphone":
            return "iphone"
        case "smartwatch":
            return "applewatch"
        case "tv":
            return "tv"
        case "headphones":
            return "headphones"
        default:
            return "doc.text.fill"
        }
    }



    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName(for: category))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 6) {
                Text(productName)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("Purchased: \(purchaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text("Warranty: \(warrantyPeriod)")
                    .font(.footnote)
                    .foregroundColor(.white)
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

       
    }
}

