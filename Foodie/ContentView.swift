//
//  ContentView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 05/03/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                launchScreenManager.dismiss()
            }
        }
    }
    
}


#Preview {
    ContentView()
        .environmentObject(LaunchScreenManager())
}
