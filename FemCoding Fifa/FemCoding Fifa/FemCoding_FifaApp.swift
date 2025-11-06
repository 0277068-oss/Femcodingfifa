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

        var body: some Scene {
            WindowGroup {
                
                if isLoggedIn {
                    ContentView(isLoggedIn: $isLoggedIn)
                } else {
                    WelcomeView(isLoggedIn: $isLoggedIn) 
                }
            }
        }
}

