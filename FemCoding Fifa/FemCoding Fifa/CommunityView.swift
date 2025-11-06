import SwiftUI

// MARK: - Vista de la Comunidad
struct CommunityView: View {
    
    // El evento seleccionado por el usuario (usa @State para que cambie la lista)
    @State private var selectedEvent: String = "Estadio Lusail - Final"
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("👭 HerGoal: Juntas a la meta")
                    .font(.title)
                    .bold()
                
                // Selector de Evento (filtros)
                Picker("Seleccionar Evento", selection: $selectedEvent) {
                    Text("Estadio Lusail - Final").tag("Estadio Lusail - Final")
                    Text("Fan Zone, Corniche").tag("Fan Zone, Corniche")
                    Text("Hotel Hilton - Check-in").tag("Hotel Hilton - Check-in")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.horizontal, .top])
                
                // Lista de Usuarias (filtrada por el evento)
                List {
                    ForEach(communityMembers.filter { $0.destination == selectedEvent }) { member in
                        
                        // ⭐️ CAMBIO AQUÍ: Se pasa el objeto 'member' a ChatView(withUser:)
                        NavigationLink(destination: ChatView(chatUser: member)){
                            HStack {
                                Text(member.emoji).font(.title)
                                
                                VStack(alignment: .leading) {
                                    Text(member.name).font(.headline)
                                    Text("📍 \(member.destination) | Hora: \(member.time)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                // Botón de contacto (simulado)
                                Image(systemName: "message.fill")
                                    // Asumiendo que "MoradoComunidad" está definido en Assets
                                    .foregroundColor(Color(red: 0.5, green: 0.3, blue: 0.8))
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Comunidad")
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
