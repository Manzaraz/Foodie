//
//  PhotoView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 12/03/2025.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot // Passed in from SpotDetailView
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            selectedImage
                .resizable()
                .scaledToFit()
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            // TODO: Save action here...
                            
                            dismiss()
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    // Turn selectedPhoto into a useable Image View
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                        } catch {
                            print("😡ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                        }
                    }
                }
            
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot())
}
