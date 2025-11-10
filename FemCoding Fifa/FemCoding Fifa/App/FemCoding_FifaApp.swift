//
//  FemCoding_FifaApp.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 03/11/25.
//

import SwiftUI

@main
struct FemCoding_FifaApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                        .environmentObject(locationManager)
                } else {
                    WelcomeView(isLoggedIn: $isLoggedIn)
                }
            }
            
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

