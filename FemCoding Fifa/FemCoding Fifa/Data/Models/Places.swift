//
//  SafePlace.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 09/11/25.
//

import SwiftUI
import MapKit

// MARK: - Estructura de Datos para Lugares
struct SafePlace: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let category: String
    let description: String
    let icon: String
    
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var color: Color {
        switch category {
        case "Personal":
            return .pink
        case "Servicio":
            return .blue
        case "Seguro":
            return Color("Verde")
        case "Recomendación":
            return Color("MoradoComunidad")
        case "Riesgo":
            return .red
        default:
            return .gray
        }
    }
    
    init(id: UUID, name: String, category: String, description: String, icon: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.icon = icon
        self.latitude = latitude
        self.longitude = longitude
    }
        
    init(name: String, category: String, description: String, icon: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.description = description
        self.icon = icon
        self.latitude = latitude
        self.longitude = longitude
    }
}
