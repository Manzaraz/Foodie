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
    @State private var photo = Photo()
    @State private var data = Data() // We need to take imaga & convert it to data to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()

            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("Description", text: $photo.description)
                .textInputAutocapitalization(.sentences)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                
                                dismiss()
                            }
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
                            
                            // Get raw data from image so we can save it to Firebase Storage
                            guard let transferedData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("😡ERROR: Could not convert data from selectedPhoto.")
                                return
                            }
                            data = transferedData
                            
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
