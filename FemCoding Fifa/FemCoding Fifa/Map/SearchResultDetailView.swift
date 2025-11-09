import SwiftUI
import MapKit

struct SearchResultDetailView: View {
    let mapItem: MKMapItem

    @State private var lookAroundScene: MKLookAroundScene?
    
    // Rutas
    // @Binding var route: MKRoute?
    @Binding var routes: [MKRoute]
    @Binding var chosenRoute: MKRoute?
    @State private var showUnsafeRouteAlert = false
    let allSafePlaces: [SafePlace]
    let currentLocation: CLLocationCoordinate2D?
    @State private var isCalculating = false
    private let routeCalculator = RouteCalculator()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text(mapItem.name ?? "Lugar")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(mapItem.placemark.title ?? "Detalle no disponible")
                .font(.headline)
                .foregroundColor(.gray)

            if let phone = mapItem.phoneNumber {
                Link(phone, destination: URL(string: "tel:\(phone)")!)
                    .font(.headline)
            }

            Divider()
            
            Button(action: {
                isCalculating = true
                Task {
                    let result = await routeCalculator.calculateSafestRoute(
                        to: .searchResult(mapItem),
                        allSafePlaces: allSafePlaces
                    )
                    
                    await MainActor.run {
                        self.routes = result.allRoutes
                        self.chosenRoute = result.chosenRoute

                        self.showUnsafeRouteAlert = !result.isSafe
                        self.isCalculating = false
                    }
                }
            }) {
                if isCalculating {
                    ProgressView()
                        .padding(.vertical, 3)
                        .frame(maxWidth: .infinity)
                } else {
                    Label("Obtener Ruta", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            .disabled(isCalculating)
            
            Text("Vista Previa del Lugar (Look Around)")
                .font(.title2)
                .fontWeight(.semibold)

            LookAroundPreview(scene: $lookAroundScene)
                .id(mapItem)
                .frame(height: 250)
                .cornerRadius(12)
                .overlay(alignment: .center) {
                    if lookAroundScene == nil {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
            
            Spacer()
        }
        .alert("Advertencia de Ruta", isPresented: $showUnsafeRouteAlert) {
                Button("Entendido", role: .cancel) { }
        } message: {
            Text("No se encontró una ruta que evite todas las zonas de alerta. Por favor, procede con precaución.")
        }
        .padding()
        .padding(.top, 80)
        .onAppear {
            getLookAroundScene()
        }
        .onChange(of: mapItem) {
            getLookAroundScene()
        }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(mapItem: mapItem)
            if let scene = try? await request.scene {
                self.lookAroundScene = scene
            }
        }
    }
}
