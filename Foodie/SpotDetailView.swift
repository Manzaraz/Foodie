//
//  SpotDetailView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import SwiftUI

struct SpotDetailView: View {
    @State var spot: Spot //  pass in value from ListView
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Group {
                TextField("Spot's Name...", text: $spot.name)
                    .font(.title2)
                
                TextField("Spot's Address...", text: $spot.address)
                    .font(.title3)
            }
            .textInputAutocapitalization(.words)
            .padding(.horizontal, 15)
            .background {
                Color(.fieldBg)
            }
            .clipShape(Capsule(style: .continuous))
            
            Spacer()
        }
        .padding(.horizontal)
        .background { BackgroundView() }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let success =  SpotViewModel.saveSpot(spot: spot)
                    if success {
                        dismiss()
                    } else {
                        print("😡 Dang! Error saving spot!")
                    }
                }
            }
        }
    }
}



#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot())
    }
}
