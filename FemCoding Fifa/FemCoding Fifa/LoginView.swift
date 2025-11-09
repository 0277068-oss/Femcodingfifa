//
//  LoginView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 06/11/25.
//


/*import SwiftUI

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
*/

/*import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(isRegistering ? "Crear Cuenta" : "Ingresar a HerGoal")) {
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    if isRegistering {
                        registerUser()
                    } else {
                        loginUser()
                    }
                } label: {
                    Text(isRegistering ? "Registrarse" : "Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    isRegistering.toggle()
                } label: {
                    Text(isRegistering ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle(isRegistering ? "Registro" : "Iniciar Sesión")
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Funciones
    
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        
        if users[email] != nil {
            alertMessage = "Ya existe una cuenta con este correo."
            showAlert = true
        } else {
            users[email] = password
            UserDefaults.standard.set(users, forKey: "users")
            alertMessage = "Cuenta creada con éxito. Ahora puedes iniciar sesión."
            showAlert = true
            isRegistering = false
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String],
           let storedPassword = users[email],
           storedPassword == password {
            // Inicio de sesión exitoso
            isLoggedIn = true
            dismiss()
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
}*/

/*import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(isRegistering ? "Crear Cuenta" : "Ingresar a HerGoal")) {
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    if isRegistering {
                        registerUser()
                    } else {
                        loginUser()
                    }
                } label: {
                    Text(isRegistering ? "Registrarse" : "Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    isRegistering.toggle()
                } label: {
                    Text(isRegistering ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle(isRegistering ? "Registro" : "Iniciar Sesión")
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Funciones
    
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        
        if users[email] != nil {
            alertMessage = "Ya existe una cuenta con este correo."
            showAlert = true
        } else {
            users[email] = password
            UserDefaults.standard.set(users, forKey: "users")
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            alertMessage = "Cuenta creada con éxito. Ahora puedes iniciar sesión."
            showAlert = true
            isRegistering = false
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String],
           let storedPassword = users[email],
           storedPassword == password {
            // Inicio de sesión exitoso
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            isLoggedIn = true
            dismiss()
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
}

*/

/*import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // 🔹 Guardar datos del usuario
    @AppStorage("savedName") private var savedName = ""
    @AppStorage("savedEmail") private var savedEmail = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(isRegistering ? "Crear Cuenta" : "Ingresar a HerGoal")) {
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    if isRegistering {
                        registerUser()
                    } else {
                        loginUser()
                    }
                } label: {
                    Text(isRegistering ? "Registrarse" : "Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    isRegistering.toggle()
                } label: {
                    Text(isRegistering ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle(isRegistering ? "Registro" : "Iniciar Sesión")
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Funciones
    
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        
        if users[email] != nil {
            alertMessage = "Ya existe una cuenta con este correo."
            showAlert = true
        } else {
            users[email] = password
            UserDefaults.standard.set(users, forKey: "users")
            UserDefaults.standard.set(email, forKey: "currentUserEmail")

            // 🔹 Guardar los datos en AppStorage
            savedEmail = email
            savedPassword = password
            savedName = "Usuario de HerGoal" // puedes cambiar esto por un TextField de nombre más adelante

            alertMessage = "Cuenta creada con éxito. Ahora puedes iniciar sesión."
            showAlert = true
            isRegistering = false
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String],
           let storedPassword = users[email],
           storedPassword == password {
            // Inicio de sesión exitoso
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            savedEmail = email  // 🔹 guarda también el correo
            isLoggedIn = true
            dismiss()
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
}
*/
/*import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // 🔹 Guardar datos del usuario
    @AppStorage("savedName") private var savedName = ""
    @AppStorage("savedEmail") private var savedEmail = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(isRegistering ? "Crear Cuenta" : "Ingresar a HerGoal")) {
                    
                    // 🔹 Solo se pide el nombre si está registrándose
                    if isRegistering {
                        TextField("Nombre completo", text: $name)
                    }
                    
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    if isRegistering {
                        registerUser()
                    } else {
                        loginUser()
                    }
                } label: {
                    Text(isRegistering ? "Registrarse" : "Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    isRegistering.toggle()
                } label: {
                    Text(isRegistering ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle(isRegistering ? "Registro" : "Iniciar Sesión")
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Funciones
    
    private func registerUser() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        var users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String] ?? [:]
        
        if users[email] != nil {
            alertMessage = "Ya existe una cuenta con este correo."
            showAlert = true
        } else {
            users[email] = password
            UserDefaults.standard.set(users, forKey: "users")
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            
            // 🔹 Guardamos nombre, correo y contraseña reales
            savedName = name
            savedEmail = email
            savedPassword = password

            alertMessage = "Cuenta creada con éxito. Ahora puedes iniciar sesión."
            showAlert = true
            isRegistering = false
        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
            showAlert = true
            return
        }
        
        if let users = UserDefaults.standard.dictionary(forKey: "users") as? [String: String],
           let storedPassword = users[email],
           storedPassword == password {
            // Inicio de sesión exitoso
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            savedEmail = email
            isLoggedIn = true
            dismiss()
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
}*/
import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(isRegistering ? "Crear Cuenta" : "Ingresar a HerGoal")) {
                    
                    if isRegistering {
                        TextField("Nombre completo", text: $name)
                    }
                    
                    TextField("Correo Electrónico", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                }
                
                Button {
                    if isRegistering {
                        registerUser()
                    } else {
                        loginUser()
                    }
                } label: {
                    Text(isRegistering ? "Registrarse" : "Ingresar")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    isRegistering.toggle()
                } label: {
                    Text(isRegistering ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .navigationTitle(isRegistering ? "Registro" : "Iniciar Sesión")
            .alert("Aviso", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Funciones
    
    private func registerUser() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            alertMessage = "Por favor completa todos los campos."
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
            
            UserDefaults.standard.set(email, forKey: "currentUserEmail")
            UserDefaults.standard.set(name, forKey: "currentUserName")
            
            alertMessage = "Cuenta creada con éxito. Ahora puedes iniciar sesión."
            showAlert = true
            isRegistering = false
        }
    }
    
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
            dismiss()
        } else {
            alertMessage = "Correo o contraseña incorrectos."
            showAlert = true
        }
    }
}

