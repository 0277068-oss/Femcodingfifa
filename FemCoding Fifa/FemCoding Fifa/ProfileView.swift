/*import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Binding var isLoggedIn: Bool
    
    // Simulación de datos del usuario
    @State private var userName: String = "Tu Nombre (Ej: Mariela"
    @State private var userCountry: String = "México"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
        @State private var selectedAvatar: Image?
    
    // Variables para el Traductor Básico
    @State private var textToTranslate: String = "Necesito ayuda, por favor."
    @State private var translatedText: String = "I need help, please."
    
    // Diccionario de traducciones simuladas (Solo para la demo)
    let translations: [String: String] = [
        "Necesito ayuda, por favor.": "I need help, please.",
        "¿Dónde está el estadio?": "Where is the stadium?",
        "Todo está bien.": "Everything is okay.",
        "Estoy aquí.": "I am here."
    ]

    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Sección 1: Perfil
                Section(header: Text("Mi Perfil en HerGoal")) {
                    HStack {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            VStack {
                                if let selectedAvatar {
                                    selectedAvatar
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)                                       .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                    .frame(width: 60, height: 60)                                      .foregroundColor(Color.purple)                                  }
                                
                                Text("Editar Foto")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            TextField("Nombre", text: $userName)
                                .font(.headline)
                            Text("País: \(userCountry)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // MARK: - Sección 2: Traductor Esencial
                Section(header: Text("🌐 Traductor Esencial (ES ➡️ EN)")) {
                    
                    // Texto Original
                    TextEditor(text: $textToTranslate)
                        .frame(height: 70)
                        .border(Color.gray.opacity(0.3))
                    
                    // Botón de Traducir (simulado)
                    Button(action: {
                        // Lógica de traducción simulada: busca en el diccionario o usa un default
                        self.translatedText = translations[self.textToTranslate] ?? "Translation not found. (Ej: I need help, please.)"
                    }) {
                        HStack {
                            Spacer()
                            Text("Traducir Mensaje")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                    }
                    
                    // Texto Traducido
                    VStack(alignment: .leading) {
                        Text("Traducción:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(translatedText)
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.top, 5)
                    }
                }
                
                // MARK: - Sección 3: Opciones
                Section(header: Text("Ajustes")) {
                    Label("Acerca de HerGoal", systemImage: "info.circle")
                    
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Cerrar Sesión", systemImage: "lock.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Ajustes y Utilidades")
        }

    }
}

*/

/*import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Binding var isLoggedIn: Bool
    
    // Simulación de datos del usuario
    @State private var userName: String = "Tu Nombre (Ej: Mariela)"
    @State private var userCountry: String = "México"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedAvatar: Image?
    
    // Variables para el Traductor Básico
    @State private var textToTranslate: String = "Necesito ayuda, por favor."
    @State private var translatedText: String = "I need help, please."
    
    // Diccionario de traducciones simuladas (Solo para la demo)
    let translations: [String: String] = [
        "Necesito ayuda, por favor.": "I need help, please.",
        "¿Dónde está el estadio?": "Where is the stadium?",
        "Todo está bien.": "Everything is okay.",
        "Estoy aquí.": "I am here."
    ]
    
    // 🔹 Preferencia guardada del modo oscuro
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Sección 1: Perfil
                Section(header: Text("Mi Perfil en HerGoal")) {
                    HStack {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            VStack {
                                if let selectedAvatar {
                                    selectedAvatar
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color.purple)
                                }
                                
                                Text("Editar Foto")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            TextField("Nombre", text: $userName)
                                .font(.headline)
                            Text("País: \(userCountry)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // MARK: - Sección 2: Traductor Esencial
                Section(header: Text("🌐 Traductor Esencial (ES ➡️ EN)")) {
                    
                    // Texto Original
                    TextEditor(text: $textToTranslate)
                        .frame(height: 70)
                        .border(Color.gray.opacity(0.3))
                    
                    // Botón de Traducir (simulado)
                    Button(action: {
                        // Lógica de traducción simulada: busca en el diccionario o usa un default
                        self.translatedText = translations[self.textToTranslate] ?? "Translation not found. (Ej: I need help, please.)"
                    }) {
                        HStack {
                            Spacer()
                            Text("Traducir Mensaje")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                    }
                    
                    // Texto Traducido
                    VStack(alignment: .leading) {
                        Text("Traducción:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(translatedText)
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.top, 5)
                    }
                }
                
                // MARK: - Sección 3: Ajustes
                Section(header: Text("Ajustes")) {
                    
                    // 🔹 Nuevo toggle para el modo oscuro
                    Toggle(isOn: $isDarkMode) {
                        Label("Modo oscuro", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Label("Acerca de HerGoal", systemImage: "info.circle")
                    
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Cerrar Sesión", systemImage: "lock.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Ajustes y Utilidades")
        }
    }
}*/

/*import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Binding var isLoggedIn: Bool
    
    // 🔹 Preferencias guardadas
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("savedName") private var savedName = ""
    @AppStorage("savedEmail") private var savedEmail = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    // Datos del usuario
    @State private var userName: String = ""
    @State private var userCountry: String = "México"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedAvatar: Image?
    
    // Traductor
    @State private var textToTranslate: String = "Necesito ayuda, por favor."
    @State private var translatedText: String = "I need help, please."
    
    let translations: [String: String] = [
        "Necesito ayuda, por favor.": "I need help, please.",
        "¿Dónde está el estadio?": "Where is the stadium?",
        "Todo está bien.": "Everything is okay.",
        "Estoy aquí.": "I am here."
    ]
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Sección 1: Perfil
                Section(header: Text("Mi Perfil en HerGoal")) {
                    HStack {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            VStack {
                                if let selectedAvatar {
                                    selectedAvatar
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color.purple)
                                }
                                
                                Text("Editar Foto")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            TextField("Nombre", text: $userName)
                                .font(.headline)
                            Text("Correo: \(savedEmail.isEmpty ? "usuario@ejemplo.com" : savedEmail)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("País: \(userCountry)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // MARK: - Sección 2: Traductor
                Section(header: Text("🌐 Traductor Esencial (ES ➡️ EN)")) {
                    TextEditor(text: $textToTranslate)
                        .frame(height: 70)
                        .border(Color.gray.opacity(0.3))
                    
                    Button(action: {
                        self.translatedText = translations[self.textToTranslate] ?? "Translation not found. (Ej: I need help, please.)"
                    }) {
                        HStack {
                            Spacer()
                            Text("Traducir Mensaje")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Traducción:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(translatedText)
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.top, 5)
                    }
                }
                
                // MARK: - Sección 3: Ajustes
                Section(header: Text("Ajustes")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Modo oscuro", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Label("Acerca de HerGoal", systemImage: "info.circle")
                    
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Cerrar Sesión", systemImage: "lock.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Ajustes y Utilidades")
            .onAppear {
                // 🔹 Cargar nombre guardado
                if userName.isEmpty {
                    userName = savedName.isEmpty ? "Tu Nombre (Ej: Mariela)" : savedName
                }
            }
        }
    }
}*/



import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State private var userName: String = UserDefaults.standard.string(forKey: "currentUserName") ?? "Tu Nombre (Ej: Mariela)"
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "currentUserEmail") ?? "correo@ejemplo.com"
    @State private var userCountry: String = "México"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedAvatar: Image?
    
    @State private var textToTranslate: String = "Necesito ayuda, por favor."
    @State private var translatedText: String = "I need help, please."
    
    let translations: [String: String] = [
        "Necesito ayuda, por favor.": "I need help, please.",
        "¿Dónde está el estadio?": "Where is the stadium?",
        "Todo está bien.": "Everything is okay.",
        "Estoy aquí.": "I am here."
    ]
    
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Sección 1: Perfil
                Section(header: Text("Mi Perfil en HerGoal")) {
                    HStack {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            VStack {
                                if let selectedAvatar {
                                    selectedAvatar
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(Color.purple)
                                }
                                
                                Text("Editar Foto")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            Text(userName)
                                .font(.headline)
                            Text(userEmail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("País: \(userCountry)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // MARK: - Sección 2: Traductor Esencial
                Section(header: Text("🌐 Traductor Esencial (ES ➡️ EN)")) {
                    TextEditor(text: $textToTranslate)
                        .frame(height: 70)
                        .border(Color.gray.opacity(0.3))
                    
                    Button(action: {
                        self.translatedText = translations[self.textToTranslate] ?? "Translation not found. (Ej: I need help, please.)"
                    }) {
                        HStack {
                            Spacer()
                            Text("Traducir Mensaje")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.green)
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Traducción:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(translatedText)
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(.top, 5)
                    }
                }
                
                // MARK: - Sección 3: Ajustes
                Section(header: Text("Ajustes")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Modo oscuro", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Label("Acerca de HerGoal", systemImage: "info.circle")
                    
                    Button(role: .destructive) {
                        isLoggedIn = false
                    } label: {
                        Label("Cerrar Sesión", systemImage: "lock.fill")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Ajustes y Utilidades")
        }
    }
}

