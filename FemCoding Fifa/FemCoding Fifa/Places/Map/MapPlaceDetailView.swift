//
//  MapPlaceDetailView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 08/11/25.
//

import SwiftUI
import MapKit

// MARK: - Vista de Detalle
struct MapPlaceDetailView: View {
    let place: SafePlace
    
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
    
    var onDelete: (SafePlace) -> Void
    var onEdit: (SafePlace) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(place.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Image(systemName: place.icon)
                        Text(place.category)
                        Spacer()
                        Menu {
                            Button {
                                onEdit(place)
                            } label: {
                                Label("Editar Lugar", systemImage: "pencil")
                            }
                            
                            Button {
                                onDelete(place)
                            } label: {
                                Label("Eliminar Lugar", systemImage: "trash")
                            }
                        } label: {
                            Label("Acciones", systemImage: "ellipsis.circle")
                                .labelStyle(.iconOnly)
                                .font(.title2)
                                .foregroundColor(.purple)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(colorForCategory(place.category))
                    
                    Text(place.description)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Button(action: {
                        isCalculating = true
                        Task {
                            let result = await routeCalculator.calculateSafestRoute(
                                to: .safePlace(place),
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
                    .tint(.purple)
                    .disabled(isCalculating)
                    
                    Text("Vista Previa")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // "Street View" de Apple
                    LookAroundPreview(scene: $lookAroundScene)
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
                .padding(40)
                .onAppear {
                    getLookAroundScene()
                }
                .onChange(of: place) {
                    getLookAroundScene()
                }
            }
        }
    }
    
    func getLookAroundScene() {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(coordinate: place.coordinate)
                if let scene = try? await request.scene {
                    self.lookAroundScene = scene
                }
            }
        }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "Servicio Básico":
            return .blue
        case "Lugar Seguro":
            return Color("Verde")
        case "Recomendación":
            return .purple
        case "Alerta":
            return .red
        default:
            return .gray
        }
    }
        
}
