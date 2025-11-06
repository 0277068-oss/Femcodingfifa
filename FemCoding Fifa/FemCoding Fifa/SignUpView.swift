import SwiftUI

struct SignUpView: View {
    
    @Binding var isLoggedIn: Bool
    
    @Environment(\.dismiss) var dismiss
    
    // Almacén para los datos del formulario
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedDestination: String = "Estadio Azteca - Partido"
    
    let destinations = [
        "Estadio Azteca - Partido",
        "Fan Zone, Zócalo",
        "Hotel Royal Pedregal"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Crea tu cuenta HerGoal")) {
                    TextField("Tu Nombre (Ej: Mariela)", text: $name)
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
                }
                
                Button(action: {
                    // --- Lógica de Registro (Simulada) ---
                    if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                        
                        let newUser = User(
                            name: name,
                            destination: selectedDestination,
                            time: "Por definir",
                            emoji: "🙋‍♀️"
                        )
                        print("¡Usuaria registrada!: \(newUser.name)")
                        
                        isLoggedIn = true
                        
                        dismiss()
                    }
                }) {
                    Text("Registrarme y Unirme")
                        .fontWeight(.bold)
                }
                .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
            }
            .navigationTitle("Registro")
        }
    }
}
