//
//  FavoritesViewModel.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Follower] = []
    @Published var emptyStateMessage = "No Favorites\nAdd one on the follower screen"
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    func retrieveFavorites() {
        do {
            let _ = try PersistenceManager.shared.retrieveFavorites()
            favorites = PersistenceManager.shared.favorites
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
    
    func remove(index: IndexSet) {
        do {
            try PersistenceManager.shared.remove(indexSet: index)
            favorites = PersistenceManager.shared.favorites
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
}
