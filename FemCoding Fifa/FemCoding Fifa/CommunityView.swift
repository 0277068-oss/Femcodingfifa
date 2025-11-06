import SwiftUI

// MARK: - Vista de la Comunidad
struct CommunityView: View {
    
    @State private var selectedEvent: String = "Estadio Azteca - Partido"
    
    // Lista dinámica de destinos únicos
    private var uniqueDestinations: [String] {
        let destinations = communityMembers.map { $0.destination }
        return Array(Set(destinations)).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("👭 HerGoal: Juntas a la meta")
                    .font(.title)
                    .bold()
                
                Picker("Seleccionar Evento", selection: $selectedEvent) {
                    
                    ForEach(uniqueDestinations, id: \.self) { destination in
                        Text(destination).tag(destination)
                    }
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.horizontal, .top])
                
                List {
                    ForEach(communityMembers.filter { $0.destination == selectedEvent }) { member in
                        
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
                                
                                Image(systemName: "message.fill")
                                    .foregroundColor(Color.purple)
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

