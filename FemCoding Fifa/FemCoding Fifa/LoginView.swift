//
//  LoginView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 06/11/25.
//


import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ingresar a HerGoal")) {
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    print("Iniciando sesión...")
                    
                    isLoggedIn = true
                    
                    dismiss()
                } label: {
                    Text("Ingresar")
                        .fontWeight(.bold)
                }
            }
            .navigationTitle("Iniciar Sesión")
        }
    }
}
