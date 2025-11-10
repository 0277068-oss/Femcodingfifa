//
//  MapSelection.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 09/11/25.
//

import SwiftUI
import MapKit

enum MapSelection: Identifiable, Hashable {
    case safePlace(SafePlace)
    case searchResult(MKMapItem)
    
    var id: AnyHashable {
        switch self {
        case .safePlace(let place): return place.id
        case .searchResult(let item): return item
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .safePlace(let place): return place.coordinate
        case .searchResult(let item): return item.placemark.coordinate
        }
    }
    
    var name: String {
        switch self {
        case .safePlace(let place): return place.name
        case .searchResult(let item): return item.name ?? "Lugar"
        }
    }
}


struct MapRegion: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let region: MKCoordinateRegion

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(emoji)
    }
    
    static func == (lhs: MapRegion, rhs: MapRegion) -> Bool {
        return lhs.name == rhs.name && lhs.emoji == rhs.emoji
    }
}

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
