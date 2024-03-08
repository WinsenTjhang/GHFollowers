//
//  FavoritesViewModel.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

@Observable
final class FavoritesViewModel {
    var favorites: [Follower] = []
    
    static let emptyStateMessage = "No Favorites\nAdd one on the follower screen"
    
    func retrieveFavorites(persistenceManager: PersistenceManager) {
        let _ = persistenceManager.retrieveFavorites()
        favorites = persistenceManager.favorites
    }
    
    func remove(index: IndexSet, persistenceManager: PersistenceManager) {
        do {
            try persistenceManager.remove(indexSet: index)
            favorites = persistenceManager.favorites
        } catch {
            print(error.localizedDescription)
            print(error)
        }
    }
}
