import SwiftUI
import PhotosUI

struct ProfileView: View {
    
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
                        .background(Color("VerdeSeguridad"))
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
                    Label("Cerrar Sesión", systemImage: "lock.fill")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Ajustes y Utilidades")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
