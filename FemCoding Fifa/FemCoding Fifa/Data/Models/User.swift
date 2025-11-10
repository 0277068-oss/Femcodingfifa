//
//  User.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 09/11/25.
//

import SwiftUI

// MARK: - Estructuras de Datos
struct User: Identifiable {
    let id = UUID()
    let name: String
    let destination: String
    let time: String
    let emoji: String
}
