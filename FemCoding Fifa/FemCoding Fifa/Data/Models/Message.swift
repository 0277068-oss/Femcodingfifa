//
//  Message.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 09/11/25.
//

import SwiftUI

// Tipos de mensaje
enum MessageRole {
    case user
    case alert
    case checkin
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool // true si lo envió el usuario actual, false si lo envió otro
    let role: MessageRole
    let url: URL? 
}
