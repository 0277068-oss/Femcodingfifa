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
    
    var goToSignUp: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Ingresar a HerGoal").foregroundColor(.purple)) {
                
                TextField("Correo Electrónico", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .tint(.purple)
                
                SecureField("Contraseña", text: $password)
                    .tint(.purple)
            }
            
            Group {
                Button {
                    loginUser()
                    
                } label: {
                    Text("Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("MoradoComunidad"))
                .controlSize(.large)
                .listRowBackground(Color.clear)
            }
            .padding(.vertical, 10)
            
            Button {
                goToSignUp()
            } label: {
                Text("¿No tienes cuenta? Regístrate")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Iniciar Sesión")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cerrar") {
                    dismiss()
                }
                .foregroundColor(.purple)
            }
        }
        .alert("Aviso", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        
    }
    
    // MARK: - Funciones
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: [String: String]],
           let userData = users[email],
                      let storedPassword = userData["password"],
           storedPassword == password {
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            UserDefaults.standard.set(userData["name"], forKey: "currentUserName")
            
            isLoggedIn = true
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
    
}

