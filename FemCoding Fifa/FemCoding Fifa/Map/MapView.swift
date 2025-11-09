import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .region(.mexicoCity)
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults: [MKMapItem] = []
    
    @State private var safePlaces = safePlacesData
    @State private var showingAddPlace = false
    @State private var newPlaceCoordinate: CLLocationCoordinate2D?
    
    @State private var selectedResult: MapSelection?
    
    // Ruta
    //@State private var route: MKRoute?
    @State private var routes: [MKRoute] = []
    @State private var chosenRoute: MKRoute? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapContent
                
                emergencyButtonOverlay
            }
            .navigationTitle("Rutas Seguras")
            .sheet(isPresented: $showingAddPlace) {
                addPlaceSheet
            }
        }
    }
    
    // --- Mapa ---
    private var mapContent: some View {
        MapReader { proxy in
            mapViewWithModifiers(proxy: proxy)
        }
    }
        
        // --- Botón de Emergencia ---
    private var emergencyButtonOverlay: some View {
        VStack {
            Spacer()
            Button(action: {
                triggerEmergencyCall()
            }) {
                Text("🚨 Alerta de Emergencia")
                    .font(.headline).foregroundColor(.white).padding()
                    .background(Color.red).clipShape(Capsule())
            }
            .padding(.bottom, 100)
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
                .stroke(.blue, lineWidth: 7)
        }
            
    }
    
    @MapContentBuilder
    private var annotationLayers: some MapContent {
        ForEach(safePlaces) { place in
            Marker(place.name, systemImage: place.icon, coordinate: place.coordinate)
                .tint(place.color)
                .tag(MapSelection.safePlace(place))
        }
        
        ForEach(searchResults, id: \.self) { result in
            Marker(item: result)
                .tag(MapSelection.searchResult(result))
        }
        //.annotationTitles(.hidden)
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
        
        // --- SUB-EXPRESIÓN 2: Los Overlays y Sheets (UI) ---
        let mapWithUI = baseMap
            .sheet(item: $selectedResult) { selection in
                VStack {
                    // Esta es la ubicación CONFIABLE de tu simulador (CDMX)
                    let userCoordinate = locationManager.location?.coordinate
                    
                    switch selection {
                    case .safePlace(let place):
                        MapPlaceDetailView(
                            place: place,
                            routes: $routes,
                            chosenRoute: $chosenRoute,
                            allSafePlaces: safePlaces,
                            currentLocation: userCoordinate 
                        )
                    case .searchResult(let mapItem):
                        SearchResultDetailView(
                            mapItem: mapItem,
                            routes: $routes,
                            chosenRoute: $chosenRoute,
                            allSafePlaces: safePlaces,
                            currentLocation: userCoordinate
                        )
                    }
                }
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    MapButtons(
                        position: $position,
                        searchResults: $searchResults,
                        visibleRegion: visibleRegion
                    )
                    Spacer()
                }
                .padding()
                .padding(.top)
                .background(.ultraThinMaterial)
            }
        
        // --- SUB-EXPRESIÓN 3: La Lógica y Gestos (Final) ---
        mapWithUI
            .onAppear {
                locationManager.start()
            }
            .onMapCameraChange { context in
                self.visibleRegion = context.region
            }
            .onChange(of: searchResults) {
                position = .automatic
            }
            .onChange(of: selectedResult) {
                if selectedResult == nil {
                    routes.removeAll()
                    chosenRoute = nil
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
                            
                            // Usa el 'proxy' que recibimos como parámetro
                            if let coordinate = proxy.convert(screenLocation, from: .local) {
                                newPlaceCoordinate = coordinate
                                showingAddPlace = true
                            }
                        default:
                            break
                        }
                    }
            )
    }
    
    @ViewBuilder
    private var addPlaceSheet: some View {
        if let coord = newPlaceCoordinate {
            
            AddSafePlaceView(coordinate: coord) { name, description, category, icon, lat, lon in
                
                let newPlace = SafePlace(
                    name: name, category: category, description: description,
                    icon: icon, latitude: lat, longitude: lon
                )
                safePlaces.append(newPlace)
            }
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
    
    // MARK: - Vista para ingresar nuevo lugar
    struct AddSafePlaceView: View {
        @Environment(\.dismiss) var dismiss
        var coordinate: CLLocationCoordinate2D
        
        // Estados para los nuevos campos
        @State private var name = ""
        @State private var description = ""
        @State private var category = "Personal"
        @State private var icon = "mappin.and.ellipse"
        
        // Opciones de íconos
        let iconOptions = [
            ("Pin", "mappin.and.ellipse"),
            ("Escudo", "shield.lefthalf.filled"),
            ("Casa", "house.fill"),
            ("Peligro", "exclamationmark.triangle.fill"),
            ("Persona", "figure.walk")
        ]
        
        var onSave: (String, String, String, String, Double, Double) -> Void
        
        var body: some View {
            NavigationStack {
                Form {
                    Section(header: Text("Información del Lugar")) {
                        TextField("Nombre del lugar", text: $name)
                        TextField("Descripción (Ej: oscuro, vigilado...)", text: $description)
                    }
                    
                    Section(header: Text("Categoría e Ícono")) {
                        Picker("Categoría", selection: $category) {
                            Text("Personal").tag("Personal")
                            Text("Lugar Seguro").tag("Lugar Seguro")
                            Text("Servicio Básico").tag("Servicio Básico")
                            Text("Recomendación").tag("Recomendación")
                            Text("Alerta").tag("Alerta")
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
                    
                    Section(header: Text("Ubicación (Solo lectura)")) {
                        Text("Latitud: \(coordinate.latitude)")
                        Text("Longitud: \(coordinate.longitude)")
                    }
                }
                .navigationTitle("Agregar lugar")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            onSave(name, description, category, icon, coordinate.latitude, coordinate.longitude)
                            dismiss()
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                    }
                }
            }
        }
    }
}


// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
