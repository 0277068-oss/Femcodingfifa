import SwiftUI

// MARK: - Lugares
struct PlacesView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedCategory: String = "Todos"
    private let safeColor = Color("Verde")
    private let accentColor = Color("MoradoComunidad")
    
    private var uniqueCategories: [String] {
        let categories = viewModel.safePlaces.map { $0.category }
        var unique = Array(Set(categories)).sorted()
        unique.insert("Todos", at: 0)
        return unique
    }
    
    private var filteredPlaces: [SafePlace] {
        if selectedCategory == "Todos" {
            return viewModel.safePlaces
        } else {
            return viewModel.safePlaces.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        NavigationStack {
            Picker("Filtrar por Categoría", selection: $selectedCategory) {
                ForEach(uniqueCategories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top, 5)
            
            ScrollView {
                VStack (spacing: 12) {
                    ForEach(filteredPlaces) { place in
                        PlaceCardView(
                            place: place,
                            safeColor: safeColor,
                            accentColor: accentColor
                        )
                    }
                }
                .padding(.horizontal) 
                .padding(.top, 10)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Lugares Seguros")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
