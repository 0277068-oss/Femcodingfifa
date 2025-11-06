import SwiftUI

// MARK: - Vista de Lugares Seguros
struct PlacesView: View {
    var body: some View {
        NavigationStack {
            List {
                // Recorremos los datos para mostrarlos en la lista
                ForEach(safePlacesData) { place in
                    HStack {
                        Image(systemName: place.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            // Usamos el color verde para simbolizar la seguridad de la ruta/lugar
                            .foregroundColor(Color("VerdeSeguridad"))
                            .padding(.trailing, 5)

                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            
                            HStack {
                                Text(place.category)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color("MoradoComunidad").opacity(0.2))
                                    .cornerRadius(8)

                                Text(place.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("🛡️ Lugares Seguros")
        }
    }
}

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView()
    }
}
