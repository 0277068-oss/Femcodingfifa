import SwiftUI

struct SignUpView: View {
    
    @Binding var isLoggedIn: Bool
    
    var goToLogin: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    // Almacén para los datos del formulario
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedDestination: String = "Estadio Azteca - Partido"
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @AppStorage("currentUserName") private var currentUserName = ""
    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    
    let destinations = [
        "Estadio Azteca - Partido",
        "Fan Zone, Zócalo",
        "Hotel Royal Pedregal"
    ]
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }
    
    var body: some View {
        Form {
            Section(header: Text("Crea tu cuenta HerGoal")) {
                TextField("Nombre", text: $name)
                TextField("Correo Electrónico", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Contraseña", text: $password)
            }
            
            Section(header: Text("Selecciona tu grupo principal")) {
                Text("Esto nos ayuda a conectarte con otras fans que van a tu mismo evento.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Picker("Tu Destino Principal", selection: $selectedDestination) {
                    ForEach(destinations, id: \.self) { destination in
                        Text(destination).tag(destination)
                    }
                }
                .tint(.purple)
            }
            
            Group {
                Button(action: {
                    registerUser()
                }) {
                    Text("Registrarme y Unirme")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("MoradoComunidad"))
                .controlSize(.large)
                .listRowBackground(Color.clear)
                .disabled(!isFormValid)
            }
            .padding(.vertical, 10)
            
            Button {
                goToLogin()
            } label: {
                Text("¿Ya tienes cuenta? Ingresa")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Registro").padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
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
    
    private func registerUser() {
        guard isFormValid else {
            alertMessage = "Por favor completa todos los campos (nombre, correo y contraseña)."
            showAlert = true
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: [String: String]] ?? [:]
        
        if users[email] != nil {
            alertMessage = "Ya existe una cuenta con este correo."
            showAlert = true
        } else {
            users[email] = ["password": password, "name": name]
            UserDefaults.standard.set(users, forKey: "users")
            
            currentUserEmail = email
            currentUserName = name
            
            print("¡Usuario registrada!: \(name)")
            
            isLoggedIn = true
        }
    }
    
}
