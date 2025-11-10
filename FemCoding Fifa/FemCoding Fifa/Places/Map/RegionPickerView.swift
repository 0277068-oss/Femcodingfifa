//
//  RegionPickerView.swift
//  FemCoding Fifa
//
//  Created by iOS Lab UPMX on 08/11/25.
//


import SwiftUI

struct RegionPickerView: View {
    
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        
        Picker("Region", selection: $viewModel.selectedAppRegion) {
            
            ForEach(availableRegions) { region in
                HStack {
                    Text(region.name)
                }
                .foregroundStyle(.primary)
                .tag(region)
            }
        }
        .pickerStyle(.menu)
        .tint(.primary)
    }
}
