//
//  Models.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 05/11/25.
//

import Foundation
import MapKit

// MARK: - Estructura de Datos para Lugares
struct SafePlace: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let description: String
    let icon: String
    let coordinate: CLLocationCoordinate2D
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

// MARK: - Datos de Prueba
// Lugares seguros
let safePlacesData = [
    SafePlace(
        name: "Hospital Médica Sur",
        category: "Servicio Básico",
        description: "Servicios de emergencia 24/7. Referente en la zona sur.",
        icon: "cross.case.fill",
        coordinate: CLLocationCoordinate2D(latitude: 19.3085, longitude: -99.1653)
    ),
    SafePlace(
        name: "Centro Comercial Paseo Acoxpa",
        category: "Lugar Seguro",
        description: "Lobby de Liverpool. Bien iluminado, con seguridad y fácil de ubicar.",
        icon: "house.fill",
        coordinate: CLLocationCoordinate2D(latitude: 19.3015, longitude: -99.1412)
    ),
    SafePlace(
        name: "Fan Zone (Simulado) Alameda Sur",
        category: "Recomendación",
        description: "Zona de fiesta con alta vigilancia y ambiente familiar.",
        icon: "figure.walk",
        coordinate: CLLocationCoordinate2D(latitude: 19.3130, longitude: -99.1384)
    ),
    SafePlace(
        name: "Café 'El Rincón Azteca'",
        category: "Lugar Seguro",
        description: "Cafetería 24h cerca del estadio. Punto de encuentro.",
        icon: "cup.and.saucer.fill",
        coordinate: CLLocationCoordinate2D(latitude: 19.3050, longitude: -99.1520)
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
