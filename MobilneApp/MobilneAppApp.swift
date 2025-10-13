//
//  MobilneAppApp.swift
//  MobilneApp
//
//  Created by Dajana Isaku on 11. 10. 2025..
//

import SwiftUI
import FirebaseCore
import Firebase


@main
struct MobilneAppApp: App {
    init() {
            FirebaseApp.configure()
        }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
