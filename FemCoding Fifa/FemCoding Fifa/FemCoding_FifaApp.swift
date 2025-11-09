//
//  FemCoding_FifaApp.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 03/11/25.
//

/*import SwiftUI

@main
struct FemCoding_FifaApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

        var body: some Scene {
            WindowGroup {
                
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    WelcomeView(isLoggedIn: $isLoggedIn) 
                }
            }
        }
}*/

import SwiftUI

@main
struct FemCoding_FifaApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = false   // 🔹 guardará la preferencia de color

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    WelcomeView(isLoggedIn: $isLoggedIn)
                }
            }
            // 🔹 Aplica el esquema de color globalmente
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

