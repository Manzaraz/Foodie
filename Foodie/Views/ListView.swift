//
//  ListView.swift
//  Foodie
//
//  Created by Christian Manzaraz on 07/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot] // Loads all "spots" documents int the array variable named spots
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(spots) { spot in
                NavigationLink {
                    SpotDetailView(spot: spot)
                } label: {
                    Text(spot.name)
                }
                .swipeActions {
                    Button(
                        "Delete",
                        systemImage: "trash.fill",
                        role: .destructive) {
                            SpotViewModel.deleteSpot(spot: spot)
                        }
                }

            }
            .listStyle(.plain)
            .font(.title2)
            .background { BackgroundView() }
            .navigationTitle("Foodie Spots:")
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
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.accentColor)
                    }
                    
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }
            }
            
        }
    }
}

#Preview {
    ListView()
}
