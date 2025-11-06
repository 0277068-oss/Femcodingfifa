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
    
    var body: some View {
        // TabView: Contenedor principal de pestañas
        TabView {
            // Pestaña 1: Mapa y Rutas Seguras
            MapView()
                .tabItem {
                    Label("Rutas Seguras", systemImage: "map.fill")
                }

            // Pestaña 2: Comunidad (Juntas al Gol)
            CommunityView()
                .tabItem {
                    Label("Comunidad", systemImage: "person.3.fill")
                }

            // Pestaña 3: Lugares Seguros / Servicios
            PlacesView()
                .tabItem {
                    Label("Lugares", systemImage: "heart.text.square.fill")
                }

            // Pestaña 4: Perfil / Más
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Mi Goal", systemImage: "person.circle.fill")
                }
        }
        .accentColor(.purple)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}

