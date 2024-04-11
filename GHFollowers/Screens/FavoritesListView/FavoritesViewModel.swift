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
    
    func retrieveFavorites() {
        let _ = PersistenceManager.shared.retrieveFavorites()
        favorites = PersistenceManager.shared.favorites
    }
    
    func remove(index: IndexSet) {
        do {
            try PersistenceManager.shared.remove(indexSet: index)
            favorites = PersistenceManager.shared.favorites
        } catch {
            print(error.localizedDescription)
            print(error)
        }
    }
}
