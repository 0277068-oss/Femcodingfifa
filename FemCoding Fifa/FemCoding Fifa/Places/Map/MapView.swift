import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .automatic
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults: [MKMapItem] = []
    
    @State private var identifiableNewPlace: IdentifiableCoordinate?
    
    @State private var selectedResult: MapSelection?
    
    @State private var searchText = ""
    
    // Ruta
    @State private var routes: [MKRoute] = []
    @State private var chosenRoute: MKRoute? = nil
    
    @State private var placeToEdit: SafePlace?
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapContent
                
                emergencyButtonOverlay
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Rutas Seguras")
                            .font(.title)
                            .bold()
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                        
                        Spacer()
                        RegionPickerView(viewModel: viewModel)
                        
                    }
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                }
            }
            .searchable(text: $searchText, prompt: "Buscar...")
        }
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                search(for: newValue)
                
            } else if newValue.isEmpty {
                searchResults = []
            }
        }
    }
    
    // --- Mapa ---
    private var mapContent: some View {
        MapReader { proxy in
            ZStack(alignment: .topLeading) {
                mapViewWithModifiers(proxy: proxy)
                if !routes.isEmpty {
                    Button {
                        routes.removeAll()
                        chosenRoute = nil
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .clipShape(Circle())
                        .padding()
                        .padding(.top, 70)
                }
                    
            }
        }
    }
        
        // --- Botón de Emergencia ---
    private var emergencyButtonOverlay: some View {
        VStack {
            Spacer()
            Button(action: {
                triggerEmergencyCall()
            }) {
                Text("Alerta de Emergencia")
                    .font(.headline).foregroundColor(.white).padding()
                    .background(Color.red.opacity(0.85))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 20)
        }
    }
    
    @MapContentBuilder
    private var routeLayers: some MapContent {
        let alternativeRoutes = routes.filter { $0 != chosenRoute }
        ForEach(alternativeRoutes, id: \.self) { route in
            MapPolyline(route)
                .stroke(.gray, style: StrokeStyle(lineWidth: 3, dash: [5]))
        }
        
        let chosenRouteArray = [chosenRoute].compactMap { $0 }
        ForEach(chosenRouteArray, id: \.self) { route in
            MapPolyline(route)
                .stroke(Color("Verde"), lineWidth: 7)
        }
            
    }
    
    @MapContentBuilder
    private var annotationLayers: some MapContent {
        ForEach(viewModel.safePlaces) { place in
            Marker(place.name, systemImage: place.icon, coordinate: place.coordinate)
                .tint(place.color)
                .tag(MapSelection.safePlace(place))
        }
        
        ForEach(searchResults, id: \.self) { result in
            Marker(item: result)
                .tag(MapSelection.searchResult(result))
        }
    }
    
    @MapContentBuilder
    private var mapLayers: some MapContent {
        routeLayers
        annotationLayers
    }
    
    @ViewBuilder
    private func mapViewWithModifiers(proxy: MapProxy) -> some View {
        
        let baseMap = Map(position: $position, selection: $selectedResult) {
            mapLayers
        }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls {
                MapUserLocationButton()
            }
            .mapControlVisibility(.visible)
        
        // Informacion de lugares
        let mapWithUI = baseMap
            .sheet(item: $selectedResult) { selection in
                VStack {
                    let userCoordinate = locationManager.location?.coordinate
                    
                    switch selection {
                    case .safePlace(let place):
                        MapPlaceDetailView(
                            place: place,
                            routes: $routes,
                            chosenRoute: $chosenRoute,
                            allSafePlaces: viewModel.safePlaces,
                            currentLocation: userCoordinate,
                            onDelete: deletePlace,
                            onEdit: startEditing
                        )
                    case .searchResult(let mapItem):
                        SearchResultDetailView(
                            mapItem: mapItem,
                            routes: $routes,
                            chosenRoute: $chosenRoute,
                            allSafePlaces: viewModel.safePlaces,
                            currentLocation: userCoordinate
                        )
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 8) {
                    HStack{
                        Spacer()
                        MapButtons(
                            position: $position,
                            searchResults: $searchResults,
                            visibleRegion: visibleRegion
                        )
                        Spacer()
                        
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
                
            }
    
        
        // Logica y gestos
        mapWithUI
            .onAppear {
                locationManager.start()
                if viewModel.selectedPlaceToCenter == nil {
                    position = .region(viewModel.selectedAppRegion.region)
                }
            }
            .onMapCameraChange { context in
                self.visibleRegion = context.region
            }
            .onChange(of: searchResults) {
                position = .automatic
            }
            .onChange(of: viewModel.selectedPlaceToCenter) { oldPlace, newPlace in
                if let place = newPlace {
                    position = .camera(MapCamera(centerCoordinate: place.coordinate, distance: 1000))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if viewModel.selectedPlaceToCenter?.id == place.id {
                            viewModel.selectedPlaceToCenter = nil
                        }
                    }
                }
            }
            .onChange(of: viewModel.selectedAppRegion) { _, newRegion in
                if viewModel.selectedPlaceToCenter == nil {
                    position = .region(newRegion.region)
                }
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                    .onEnded { value in
                        switch value {
                        case .second(true, let drag):
                            guard let drag = drag else { return }
                            let screenLocation = drag.location
                            
                            if let coordinate = proxy.convert(screenLocation, from: .local) {
                                identifiableNewPlace = IdentifiableCoordinate(coordinate: coordinate)
                            }
                        default:
                            break
                        }
                    }
            )
            .sheet(item: $identifiableNewPlace) { coord in
                AddSafePlaceView(
                    placeToEdit: nil,
                    coordinate: coord.coordinate
                ) { name, description, category, icon, lat, lon in
                    let newPlace = SafePlace(
                        name: name, category: category, description: description,
                        icon: icon, latitude: lat, longitude: lon
                    )
                    viewModel.safePlaces.append(newPlace)
                    identifiableNewPlace = nil
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .sheet(item: $placeToEdit) { place in
                AddSafePlaceView(
                    placeToEdit: place,
                    coordinate: place.coordinate
                ) { name, description, category, icon, lat, lon in
                    let updatedPlace = SafePlace(
                        id: place.id,
                        name: name, category: category, description: description,
                        icon: icon, latitude: lat, longitude: lon
                    )
                    saveEditedPlace(editedPlace: updatedPlace)
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
    }
    
    private func triggerEmergencyCall() {
        guard let countryCode = Locale.current.region?.identifier else {
            print("No se pudo determinar la región del dispositivo.")
            dial(number: "112")
            return
        }
        
        if let number = AppConstants.emergencyNumbers[countryCode] {
            print("Región detectada: \(countryCode). Marcando: \(number)")
            dial(number: number)
        } else {
            print("Región \(countryCode) no encontrada. Marcando número universal 112.")
            dial(number: "112")
        }
    }
    
    // Abrir la app Teléfono
    private func dial(number: String) {
        guard let url = URL(string: "tel://\(number)") else {
            print("Error: El número de teléfono no es válido.")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.open(url)
        } else {
            print("Error: Este dispositivo no puede realizar llamadas.")
        }
        
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        request.region = visibleRegion ?? .mexicoCity
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            await MainActor.run {
                searchResults = response?.mapItems ?? []
            }
        }
    }
    
    func deletePlace(placeToDelete: SafePlace) {
        viewModel.deletePlace(placeToDelete: placeToDelete)
        if case .safePlace(let selected) = selectedResult, selected.id == placeToDelete.id {
            selectedResult = nil
        }
    }

    func startEditing(place: SafePlace) {
        selectedResult = nil
        DispatchQueue.main.async {
            placeToEdit = place
        }
    }
    
    func saveEditedPlace(editedPlace: SafePlace) {
        viewModel.saveEditedPlace(editedPlace: editedPlace)
        DispatchQueue.main.async {
            placeToEdit = nil
            selectedResult = nil
        }
    }
    
    // MARK: - Nuevo lugar
    struct AddSafePlaceView: View {
        @Environment(\.dismiss) var dismiss
        var placeToEdit: SafePlace?
        var coordinate: CLLocationCoordinate2D
        
        // Estados para los nuevos campos
        @State private var name: String
        @State private var description: String
        @State private var category: String
        @State private var icon: String
        
        // Opciones de íconos
        let iconOptions = [
            ("Pin", "mappin.and.ellipse"),
            ("Escudo", "shield.lefthalf.filled"),
            ("Casa", "house.fill"),
            ("Peligro", "exclamationmark.triangle.fill"),
            ("Persona", "figure.walk")
        ]
        
        var onSave: (String, String, String, String, Double, Double) -> Void
        
        init(placeToEdit: SafePlace? = nil, coordinate: CLLocationCoordinate2D, onSave: @escaping (String, String, String, String, Double, Double) -> Void) {
                
                self.placeToEdit = placeToEdit
                self.coordinate = coordinate
                self.onSave = onSave
                
                _name = State(initialValue: placeToEdit?.name ?? "")
                _description = State(initialValue: placeToEdit?.description ?? "")
                _category = State(initialValue: placeToEdit?.category ?? "Personal")
                _icon = State(initialValue: placeToEdit?.icon ?? "mappin.and.ellipse")
            }
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Información del Lugar").foregroundColor(.purple)) {
                        TextField("Nombre del lugar", text: $name)
                        TextField("Descripción (Ej: oscuro, vigilado...)", text: $description)
                    }
                    
                    Section(header: Text("Categoría e Ícono").foregroundColor(.purple)) {
                        Picker("Categoría", selection: $category) {
                            Text("Personal").tag("Personal")
                            Text("Seguro").tag("Seguro")
                            Text("Servicio").tag("Servicio")
                            Text("Recomendación").tag("Recomendación")
                            Text("Riesgo").tag("Riesgo")
                        }
                        
                        Picker("Ícono", selection: $icon) {
                            ForEach(iconOptions, id: \.1) { (name, systemName) in
                                HStack {
                                    Image(systemName: systemName)
                                    Text(name)
                                }
                                .tag(systemName)
                            }
                        }
                    }
                    
                    Section(header: Text("Ubicación").foregroundColor(.purple)) {
                        Text("Latitud: \(coordinate.latitude)")
                        Text("Longitud: \(coordinate.longitude)")
                    }
                }
                .navigationTitle(placeToEdit == nil ? "Agregar Nuevo Lugar" : "Editar \(placeToEdit?.name ?? "Lugar")")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            onSave(name, description, category, icon, coordinate.latitude, coordinate.longitude)
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("Verde"))
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                            .foregroundColor(.purple)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.regularMaterial)
            }
            .tint(.purple)
        }
    }
}


// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
