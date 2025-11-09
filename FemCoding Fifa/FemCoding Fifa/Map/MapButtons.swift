//
//  MapButtons.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 05/11/25.
//

import SwiftUI
import MapKit

struct MapButtons: View {
    
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack(spacing: 12) {
            
            // --- BOTONES DE BÚSQUEDA ---
            Button {
                search(for: "Estadios")
            } label: {
                Label("Estadios", systemImage: "sportscourt.fill")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "Hoteles")
            } label: {
                Label("Hoteles", systemImage: "bed.double.fill")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            // --- BOTONES DE REGIÓN ---
            Button {
                position = .region(.mexicoCity)
            } label: {
                Label("México DF", systemImage: "m.circle.fill")
            }
            .buttonStyle(.bordered)
            
            Button {
                position = .region(.newYorkNewJersey)
            } label: {
                Label("NY/NJ", systemImage: "n.circle.fill")
            }
            .buttonStyle(.bordered)
            
            Button {
                position = .region(.vancouver)
            } label: {
                Label("Vancouver", systemImage: "v.circle.fill")
            }
            .buttonStyle(.bordered)
        }
        .labelStyle(.iconOnly) 
    }
    
    // --- Función de Búsqueda ---
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        request.region = visibleRegion ?? .mexicoCity
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            await MainActor.run {
                searchResults = response?.mapItems ?? []
            }
        }
    }
}
