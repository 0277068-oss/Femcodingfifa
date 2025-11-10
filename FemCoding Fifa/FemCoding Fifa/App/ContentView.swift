//
//  ContentView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 03/11/25.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @StateObject var viewModel = AppViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            // Pestaña 1: Mapa y Rutas Seguras
            MapView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Rutas Seguras", systemImage: "map.fill")
                }
                .tag(0)

            // Pestaña 2: Comunidad (Juntas al Gol)
            CommunityView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Comunidad", systemImage: "person.3.fill")
                }
                .tag(1)

            // Pestaña 3: Lugares Seguros / Servicios
            PlacesView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Lugares", systemImage: "heart.text.square.fill")
                }
                .tag(2)

            // Pestaña 4: Perfil / Más
            ProfileView(isLoggedIn: $isLoggedIn)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Mi Goal", systemImage: "person.circle.fill")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}
