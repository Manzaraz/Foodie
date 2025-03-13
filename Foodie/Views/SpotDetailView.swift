//
//  SpotDetailView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpotDetailView: View {
    @FirestoreQuery(collectionPath: "spots") var photos: [Photo]
    @State var spot: Spot //  pass in value from ListView
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false // Alert user if they need to save Spot before adding a photo
    @State private var alertMessage = "Cannot add a Photo until you save the Spot."
    
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
            .autocorrectionDisabled()
            .padding(.horizontal, 15)
            .background {
                Color(.fieldBg)
            }
            .clipShape(Capsule(style: .continuous))
            
            Button { // Photo Button
                // TODO: Photo Action button here
                if spot.id == nil { // Ask if you want to save it.
                    showingAlert.toggle()
                } else { //  Go right to the PhotoView
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.accent)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageURLString)
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipped()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .frame(height: 80)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .background { BackgroundView() }
        .navigationBarBackButtonHidden()
        .task {
            $photos.path = "spots/\(spot.id ?? "")/photos"
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            
            Button("Save") {
                //  We want to return spot.id after saving a new Spot. Right now it's nil
                Task {
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                        print("😡ERROR: Saving spot in alert return nil")
                        return
                    }
                    
                    spot.id = id
                    print("spot.id: \(id)")
                    photoSheetIsPresented.toggle() // Now open sheet & move to PhotoView
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
    }
}



#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot(id: "1", name: "Beans Coffee", address: "Yerba Buena"))
    }
}

extension SpotDetailView {
    
    func saveSpot() {
        Task {
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                print("😡ERROR: Saving spot form Save button.")
                return
            }
            
            print("spot.id: \(id)")
            print("😎 Nice Spot save!")
        }
    }
}
