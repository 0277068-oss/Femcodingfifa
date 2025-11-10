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
    
    private var hasSearchResults: Bool {
        !searchResults.isEmpty
    }
    
    var body: some View {
        HStack(spacing: 12) {
            
            // --- BOTONES DE BÚSQUEDA ---
            Button {
                searchCategory(for: "Estadios")
            } label: {
                Label("Estadios", systemImage: "sportscourt")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                searchCategory(for: "Hoteles")
            } label: {
                Label("Hoteles", systemImage: "bed.double")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                searchCategory(for: "Hospitales")
            } label: {
                Label("Hospitales", systemImage: "cross.case")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                searchCategory(for: "Bancos")
            } label: {
                Label("Bancos", systemImage: "banknote")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            if hasSearchResults {
                Button {
                    resetSearch()
                } label: {
                    Label("Borrar", systemImage: "xmark.circle.fill")
                }
                .tint(.gray)
            }
            
        }
        .font(.title3)
        .labelStyle(.iconOnly)
    }
    
    func resetSearch() {
        searchResults = []
    }
    
    // --- Función de Búsqueda ---
    func searchCategory(for query: String) {
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
