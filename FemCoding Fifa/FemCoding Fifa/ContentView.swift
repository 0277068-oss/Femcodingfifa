//
//  ContentView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 03/11/25.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
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
            ProfileView()
                .tabItem {
                    Label("Mi Goal", systemImage: "person.circle.fill")
                }
        }
        // Usamos tu color MoradoComunidad para los iconos seleccionados
        .accentColor(Color("MoradoComunidad"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
// Previews...
