//
//  SafePlace.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 08/11/25.
//


import SwiftUI
import Combine

final class AppViewModel: ObservableObject {
    @Published var safePlaces: [SafePlace] = safePlacesData
    
    @Published var selectedPlaceToCenter: SafePlace? = nil
    @Published var selectedAppRegion: MapRegion = availableRegions[0]
    
    @Published var selectedTab: Int = 0
    
    func saveEditedPlace(editedPlace: SafePlace) {
            if let index = safePlaces.firstIndex(where: { $0.id == editedPlace.id }) {
                safePlaces[index] = editedPlace
            }
        }
        
    func deletePlace(placeToDelete: SafePlace) {
        safePlaces.removeAll { $0.id == placeToDelete.id }
    }
    
    func filteredCommunityMembers() -> [User] {
        if selectedAppRegion.name.contains("CDMX") {
            return communityMembers.filter { $0.destination.contains("Azteca") }
        }
        return communityMembers
    }
}
