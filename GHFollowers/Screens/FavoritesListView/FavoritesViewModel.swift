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
    
    private let persistenceManager: PersistenceManagerProtocol
    
    init(persistenceManager: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.persistenceManager = persistenceManager
    }
    
    func retrieveFavorites() {
        do {
            let _ = try persistenceManager.retrieveFavorites()
            favorites = persistenceManager.favorites
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
    
    func remove(index: IndexSet) {
        do {
            try persistenceManager.remove(indexSet: index)
            favorites = persistenceManager.favorites
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
}
