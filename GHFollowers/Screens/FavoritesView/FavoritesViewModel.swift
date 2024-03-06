//
//  FavoritesViewModel.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import Foundation

@Observable
final class FavoritesViewModel {
    let persistenceManager = PersistenceManager()
    var favorites: [Follower] = []
    
    static let emptyStateMessage = "No Favorites\nAdd one on the follower screen"
    
    func retrieveFavorites() {
        let _ = persistenceManager.retrieveFavorites()
        favorites = persistenceManager.favorites
    }
    
    func remove(index: IndexSet) {
        do {
            try persistenceManager.remove(indexSet: index)
        } catch {
            print("remove function error")
        }
    }
}
