//
//  LaunchScreenManager.swift
//  Foodie
//
//  Created by Christian Manzaraz on 05/03/2025.
//

import Foundation

enum LaunchScreenPhase {
    case first, second, completed
}


final class LaunchScreenManager: ObservableObject {
    @Published private(set) var state: LaunchScreenPhase = .first
    
    func dismiss() {
        
        self.state = .second
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .completed
        }
    }
}


