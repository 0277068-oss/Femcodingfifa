//
//  PlaceCardView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 09/11/25.
//

import SwiftUI

struct PlaceCardView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    let place: SafePlace
    let safeColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: place.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.primary)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(place.description)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text(place.category.uppercased())
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(accentColor.opacity(0.15))
                        .cornerRadius(6)
                    
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            viewModel.selectedPlaceToCenter = place
            viewModel.selectedTab = 0
            
        }
    }
}
