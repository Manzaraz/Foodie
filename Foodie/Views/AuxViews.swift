//
//  BackgroundView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [ Color(.systemBackground), Color(.systemBlue).opacity(0.5), Color(.screenBg)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}



#Preview {
    BackgroundView()
}
