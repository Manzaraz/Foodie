//
//  SpotViewModel.swift
//  Foodie
//
//  Created by Christian Manzaraz on 08/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
    
    static func saveSpot(spot: Spot) -> Bool {
        let db = Firestore.firestore()
        
        if let id  = spot.id { // if true the spoot exists
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("😎 Data updatad successfuly!")
                return true
            } catch  {
                print("😡DB ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else { // We need to add a new spot & create a new id / document name
            do {
                try db.collection("spots").addDocument(from: spot)
                print("🐣 Data added successfuly!")
                return true
            } catch  {
                print("😡DB ERROR: Could not add data in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        
        guard let id = spot.id else {
            print("😡 No spot.id")
            return
        }
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
                print("🙂‍↔️ Spot Successfully Deleted!")
            } catch {
                print("😡ERROR: Could not delete spot.id \(id). \(error.localizedDescription)")
            }
        }
    }
}

