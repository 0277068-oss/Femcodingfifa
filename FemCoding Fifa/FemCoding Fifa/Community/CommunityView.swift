import SwiftUI

// MARK: - Vista de la Comunidad
struct CommunityView: View {
    
    @State private var selectedEvent: String = "Estadio Azteca - Partido"
    
    let communityAccentColor = Color("MoradoComunidad")
    
    // Lista dinámica de destinos únicos
    private var uniqueDestinations: [String] {
        let destinations = communityMembers.map { $0.destination }
        return Array(Set(destinations)).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("HerGoal: Juntas a la meta")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                Picker("Seleccionar Evento", selection: $selectedEvent) {
                    
                    ForEach(uniqueDestinations, id: \.self) { destination in
                        Text(destination).tag(destination)
                    }
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                .tint(communityAccentColor)
                .padding(.horizontal)
                
                List {
                    ForEach(communityMembers.filter { $0.destination == selectedEvent }) { member in
                        
                        NavigationLink(destination: ChatView(chatUser: member)){
                            HStack {
                                Text(member.emoji).font(.title)
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(member.name).font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(communityAccentColor)
                                    Text("📍 \(member.destination) | Hora: \(member.time)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "message.fill")
                                    .foregroundColor(communityAccentColor)
                                    .font(.callout)
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color(.secondarySystemGroupedBackground))
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Comunidad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TranslatorView()) {
                        Text("文")
                            .bold()
                            .foregroundColor(communityAccentColor)
                    }
                }
            }
        }
        .tint(communityAccentColor)
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}

