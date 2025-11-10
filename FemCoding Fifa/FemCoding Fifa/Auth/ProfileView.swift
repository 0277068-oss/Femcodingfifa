import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Binding var isLoggedIn: Bool
    
    // Datos del usuario
    @State private var userName: String = UserDefaults.standard.string(forKey: "currentUserName") ?? "Nombre"
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "currentUserEmail") ?? "correo@ejemplo.com"
    @State private var userCountry: String = "México"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedAvatar: Image?
    
    // Ajustes
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Perfil
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
                
                // MARK: - Ajustes e Información
                Section(header: Text("Ajustes")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Modo oscuro", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    
                    Label("Acerca de HerGoal", systemImage: "info.circle")
                    
                    Button(role: .destructive) {
                        // Lógica de cierre de sesión
                        UserDefaults.standard.removeObject(forKey: "currentUserName")
                        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
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
