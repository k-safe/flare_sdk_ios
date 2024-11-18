//
//  RegionDropDown.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 22/08/24.
//

import SwiftUI

struct RegionDropDown: View {
    @ObservedObject var regionSelection: RegionSelection
    var regions: [String]

    var body: some View {
        HStack {
            Text("Select a Region:")
                .font(.headline)
            
            Picker("Regions", selection: $regionSelection.selectedRegion) {
                ForEach(regions, id: \.self) { region in
                    Text(region)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Dropdown style
        }
//        .padding()

    }
}

