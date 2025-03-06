//
//  LaunchScreenView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 05/03/2025.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var firstPhaseIsAnimating: Bool = false
    @State private var secondPhaseIsAnimating: Bool = false
    
    private let timer = Timer.publish(
        every: 0.65,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        ZStack {
            background
            logo
                .padding()
        }
        .onReceive(timer) { input in
            
            switch launchScreenManager.state {
            case .first:
                withAnimation(.spring()) {
                    // First fase withcontinous scaling
                    firstPhaseIsAnimating.toggle()
                }
            case .second:
                withAnimation(.easeInOut(duration: 0.55)) {
                    // First fase withcontinous scaling
                    secondPhaseIsAnimating.toggle()
                }
            default: break
                
            }
        }
        .opacity(secondPhaseIsAnimating ? 0 : 1)
    }
}

#Preview {
    LaunchScreenView()
        .environmentObject(LaunchScreenManager())
}


private extension LaunchScreenView {
    var background: some View {
        Color("launchScreenBg")
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View {
        Image("logoIcon")
            .resizable()
            .scaledToFit()
            .scaleEffect(firstPhaseIsAnimating ? 0.85 : 1)
            .scaleEffect(secondPhaseIsAnimating ? UIScreen.main.bounds.size.height / 2 : 1)
    }
}
