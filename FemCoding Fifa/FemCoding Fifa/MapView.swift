import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var position: MapCameraPosition = .region(.mexicoCity)
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults: [MKMapItem] = []
    
    @State private var safePlaces = safePlacesData
    @State private var showingAddPlace = false
    @State private var newPlaceCoordinate: CLLocationCoordinate2D?
    @State private var mapReaderProxy: MapProxy?
    
    @State private var selectedPlace: SafePlace?

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
            Map(position: $position) {
                
                ForEach(safePlaces) { place in
                    Annotation(place.name, coordinate: place.coordinate) {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.8)).frame(width: 44, height: 44)
                            Circle().fill(Color.purple).frame(width: 38, height: 38)
                            Image(systemName: place.icon).font(.headline).foregroundColor(.white)
                        }
                        .shadow(radius: 5)
                    }
                }
                
                // Marcadores de Búsqueda (Estadios, Hoteles)
                ForEach(searchResults, id: \.self) { result in
                    Marker(item: result)
                }
                .annotationTitles(.hidden)
                
            }
            .mapStyle(.standard(elevation: .realistic))
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
            .mapControls {
                MapUserLocationButton()
            }
            .mapControlVisibility(.visible)
            .onAppear {
                self.mapReaderProxy = proxy
            }
            .onMapCameraChange { context in
                self.visibleRegion = context.region
            }
            .onChange(of: searchResults) {
                position = .automatic
            }
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                    .onEnded { value in
                        switch value {
                        case .second(true, let drag):
                            guard let drag = drag, let mapReaderProxy = mapReaderProxy else { return }
                            let screenLocation = drag.location
                            
                            if let coordinate = mapReaderProxy.convert(screenLocation, from: .local) {
                                newPlaceCoordinate = coordinate
                                showingAddPlace = true
                            }
                        default:
                            break
                        }
                    }
            )
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
    
    @ViewBuilder
    private var addPlaceSheet: some View {
        if let coord = newPlaceCoordinate {
            AddSafePlaceView(coordinate: coord) { name, description, category, icon, coordinate in
                let newPlace = SafePlace(
                    name: name, category: category, description: description,
                    icon: icon, coordinate: coordinate
                )
                safePlaces.append(newPlace)
            }
        }
    }

        private func triggerEmergencyCall() {
            // Obtiene el código de región
            guard let countryCode = Locale.current.region?.identifier else {
                print("No se pudo determinar la región del dispositivo.")
                dial(number: "112")
                return
            }

            // Busca el número en diccionario
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
}

// MARK: - Vista para ingresar nuevo lugar (Tu código)
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

    var onSave: (String, String, String, String, CLLocationCoordinate2D) -> Void
    
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
                        Text("Punto Seguro").tag("Punto Seguro")
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
                        onSave(name, description, category, icon, coordinate)
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

// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
