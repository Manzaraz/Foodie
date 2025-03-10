//
//  Spot.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import Foundation
import FirebaseFirestore


struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    
    
}
