//
//  PhotoViewModel.swift
//  Foodie
//
//  Created by Christian Manzaraz on 13/03/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    
    
    static func saveImage(spot: Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {
            print("😡ERROR: Should never have been called without a valid spot.id")
            return
        }
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString // Create a unique filename for the photo about to be saved
        }
        
        metadata.contentType = "image/jpeg" // Will allow image to be viewed in the browser from Firestore console
        
        let path = "\(id)/\(photo.id ?? "n/a")" // id is the name of the Spot document (spot.id). All photos for a spot will be saved in a "folder" with its Spot document name.
        
        do {
            let storageRef = storage.child(path)
            let returnedMetadata = try await storageRef.putDataAsync(data, metadata: metadata)
            print("😎SAVED! \(returnedMetadata)")
            
            // get URL that we'll use to load the image
            guard let url = try? await storageRef.downloadURL() else {
                print("😡ERROR: could not get downloadURL ")
                return
            }
            photo.imageURLString = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLString)")
            
            // Now that photo file is saved to Storage, save a Photo document to the spot.id's "photos" collection
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("😡ERROR: Could not update data in spots/\(id)/photos/\(photo.id ?? "n/a"). \n\(error.localizedDescription)")
            }
        } catch {
            print("😡ERROR saving photo to Storage \(error.localizedDescription)")
        }
        
    }
}

