//
//  dedicada.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 08/11/25.
//


import MapKit
import CoreLocation

struct RouteCalculator {
    
    private let unsafeDistance: CLLocationDistance = 500.0


    func calculateSafestRoute(to destination: MapSelection, allSafePlaces: [SafePlace]) async -> (allRoutes: [MKRoute], chosenRoute: MKRoute?, isSafe: Bool) {
        
        let source = MKMapItem.forCurrentLocation()
        
        let destinationCoordinate: CLLocationCoordinate2D
        switch destination {
            case .safePlace(let place):
                destinationCoordinate = place.coordinate
            case .searchResult(let mapItem):
                destinationCoordinate = mapItem.placemark.coordinate
        }
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        
        // Crear la solicitud de ruta
        let request = MKDirections.Request()
        request.source = source
        request.destination = destinationItem
        request.transportType = .walking
        request.requestsAlternateRoutes = true // rutas alternativas
        
        // Calcular las rutas
        let directions = MKDirections(request: request)
        let response: MKDirections.Response
        
        do {
            response = try await directions.calculate()
        } catch {
            
            print("Error al calcular la ruta (MKDirections.calculate): \(error.localizedDescription)")
            
            if let clError = error as? CLError {
                print("Detalle del error: CLError Code \(clError.code) (Code 0 es 'locationUnknown')")
            }
            
            return (allRoutes: [], chosenRoute: nil, isSafe: true)
        }
        let filterResult = findSafestRoute(from: response.routes, allSafePlaces: allSafePlaces)
        
        return (allRoutes: response.routes, chosenRoute: filterResult.route, isSafe: filterResult.isSafe)
    }
    
    
    private func findSafestRoute(from routes: [MKRoute], allSafePlaces: [SafePlace]) -> (route: MKRoute?, isSafe: Bool) {
        
        // Obtener zonas de peligro
        let dangerZones = allSafePlaces.filter { $0.category == "Riesgo" }
        
        guard !dangerZones.isEmpty, let fastestRoute = routes.first else {
            return (routes.first, true) // No hay peligros, la más rápida es segura
        }
        
        var safeRoutes: [MKRoute] = []
        
        for route in routes {
            var routeIsPotentiallyUnsafe = false
            
            for step in route.steps {
                // Comparar cada paso con cada zona de peligro
                for zone in dangerZones {
                    let stepLocation = CLLocation(latitude: step.polyline.coordinate.latitude, longitude: step.polyline.coordinate.longitude)
                    let zoneLocation = CLLocation(latitude: zone.latitude, longitude: zone.longitude)
                    
                    let distance = stepLocation.distance(from: zoneLocation)
                    
                    if distance < unsafeDistance {
                        routeIsPotentiallyUnsafe = true
                        break
                    }
                }
                if routeIsPotentiallyUnsafe {
                    break
                }
            }
            
            if !routeIsPotentiallyUnsafe {
                safeRoutes.append(route)
            }
        }
        
        // Decisión final
        if !safeRoutes.isEmpty {
            return (safeRoutes.first, true)
        } else {
            // No hay rutas seguras. Devolvemos la más rápida pero avisamos que no es segura.
            return (fastestRoute, false)
        }
    }
}
