//
//  ListView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [ Color(.systemBackground), Color(.screenBg).opacity(0.4), Color(.screenBg)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                List {
                    Text("List items will go here!")
                }
                .listStyle(.plain)
                .navigationTitle("Fodie Spots:")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("👋🏼 Log out successful!")
                                dismiss()
                            } catch {
                                print("😡ERROR: Could not sign out!")
                                
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // TODO: Add record code here!
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color.accentColor)
                        }
                        
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    ListView()
}
