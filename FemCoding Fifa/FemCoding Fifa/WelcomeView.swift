//
//  WelcomeView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 06/11/25.
//


import SwiftUI

struct WelcomeView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var showingLoginSheet = false
    @State private var showingSignUpSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.purple)
            
            Text("Bienvenida a HerGoal")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Tu compañera de seguridad en el mundial.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // 2. Botones de Acción
            Button {
                showingSignUpSheet = true
            } label: {
                Text("Registrarse")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            
            Button {
                showingLoginSheet = true
            } label: {
                Text("Ya tengo cuenta (Ingresar)")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            
        }
        .padding()
        .sheet(isPresented: $showingSignUpSheet) {
            SignUpView(isLoggedIn: $isLoggedIn)
        }
        .sheet(isPresented: $showingLoginSheet) {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
