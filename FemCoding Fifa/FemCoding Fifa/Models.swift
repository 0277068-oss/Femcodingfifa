//
//  Models.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 05/11/25.
//

import SwiftUI
import Foundation
import MapKit

// MARK: - Estructura de Datos para Lugares
struct SafePlace: Identifiable, Hashable {
    let id = UUID()
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
        case "Servicio Básico":
            return .blue
        case "Lugar Seguro":
            return Color("Verde")
        case "Recomendación":
            return Color("MoradoComunidad")
        case "Alerta":
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Estructuras de Datos
struct User: Identifiable {
    let id = UUID()
    let name: String
    let destination: String
    let time: String
    let emoji: String
}

// MARK: - 1. Estructura de Datos para Mensajes
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool // true si lo envió el usuario actual, false si lo envió otro
}

enum MapSelection: Identifiable, Hashable {
    case safePlace(SafePlace)
    case searchResult(MKMapItem)
    
    var id: AnyHashable {
        switch self {
        case .safePlace(let place): return place.id
        case .searchResult(let item): return item
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .safePlace(let place): return place.coordinate
        case .searchResult(let item): return item.placemark.coordinate
        }
    }
    
    var name: String {
        switch self {
        case .safePlace(let place): return place.name
        case .searchResult(let item): return item.name ?? "Lugar"
        }
    }
}

// MARK: - Datos de Prueba
// Lugares seguros
let safePlacesData = [
    SafePlace(
        name: "Hospital Médica Sur",
        category: "Servicio Básico",
        description: "Servicios de emergencia 24/7. Referente en la zona sur.",
        icon: "cross.case.fill",
        latitude: 19.298244857593144,
        longitude: -99.13756295268541
    ),
    SafePlace(
        name: "Centro Comercial Paseo Acoxpa",
        category: "Lugar Seguro",
        description: "Lobby de Liverpool. Bien iluminado, con seguridad y fácil de ubicar.",
        icon: "house.fill",
        latitude: 19.3015,
        longitude: -99.1412
    ),
    SafePlace(
        name: "Fan Zone (Simulado) Alameda Sur",
        category: "Recomendación",
        description: "Zona de fiesta con alta vigilancia y ambiente familiar.",
        icon: "figure.walk",
        latitude: 19.3130,
        longitude: -99.1384
    ),
    SafePlace(
        name: "Café 'El Rincón Azteca'",
        category: "Lugar Seguro",
        description: "Cafetería 24h cerca del estadio. Punto de encuentro.",
        icon: "cup.and.saucer.fill",
        latitude: 19.3050,
        longitude: -99.1520
    )
]

// Miembros de la comunidad
let communityMembers = [
    User(name: "Sofía M.", destination: "Estadio Azteca - Partido", time: "18:00", emoji: "🏟️"),
    User(name: "Elena P.", destination: "Fan Zone, Zócalo", time: "20:30", emoji: "🎉"),
    User(name: "Andrea G.", destination: "Hotel Royal Pedregal", time: "11:00", emoji: "🧳"),
    User(name: "Valeria R.", destination: "Estadio Azteca - Partido", time: "17:45", emoji: "⚽"),
    User(name: "Carla D.", destination: "Fan Zone, Zócalo", time: "20:00", emoji: "👯")
]

// Extensiones para las sedes del Mundial 2026
extension MKCoordinateRegion {
    
    // Sede de México: Ciudad de México (Estadio Azteca)
    static let mexicoCity = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 19.3029, longitude: -99.1504),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Sede de EE.UU.: Nueva York / Nueva Jersey (MetLife Stadium, Final)
    static let newYorkNewJersey = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.8135, longitude: -74.0745),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // Sede de Canadá: Vancouver (BC Place)
    static let vancouver = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 49.2767, longitude: -123.1119),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
}
