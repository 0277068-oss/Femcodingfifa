//
//  WelcomeView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 06/11/25.
//


import SwiftUI

enum AuthFlowState: Identifiable {
    var id: AuthFlowState { self }
    case login
    case signUp
}

struct WelcomeView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var showingAuthSheet = false
    @State private var currentFlow: AuthFlowState? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .foregroundColor(.purple)
            
            Text("Bienvenido a HerGoal")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Tu compañera de seguridad en el mundial.")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            // 2. Botones de Acción
            Button {
                currentFlow = .signUp
                showingAuthSheet = true
            } label: {
                Text("Registrarse")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            
            Button {
                currentFlow = .login
                showingAuthSheet = true
            } label: {
                Text("Ingresar")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            
        }
        .padding()
        .sheet(item: $currentFlow) { flow in
            NavigationStack {
                Group {
                    switch flow {
                    case .login:
                        LoginView(
                            isLoggedIn: $isLoggedIn,
                            goToSignUp: { currentFlow = .signUp }
                        )
                    case .signUp:
                        SignUpView(
                            isLoggedIn: $isLoggedIn,
                            goToLogin: { currentFlow = .login }
                        )
                    }
                }
                .id(flow)
                .scrollContentBackground(.hidden)
                .background(.regularMaterial)
                .tint(.purple)
            }
        }
        .onChange(of: isLoggedIn) { _, newValue in
            if newValue {
                showingAuthSheet = false
            }
        }
    }
}
