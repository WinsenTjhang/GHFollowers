//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

final class PersistenceManager {
    static let shared = PersistenceManager()
    @AppStorage("userFavorites") private var userData: Data?
    var favorites: [Follower] = []
    
    func add(favorite: Follower) throws {
        guard !favorites.contains(favorite) else { throw PersistenceError.alreadyInFavorites }
        favorites.append(favorite)
        try saveFavorites()
    }
    
    func remove(indexSet: IndexSet) throws {
        favorites.remove(atOffsets: indexSet)
        try saveFavorites()
    }
    
    func retrieveFavorites() throws {
        guard let favoritesData = userData else { return }
        
        do {
            favorites = try JSONDecoder().decode([Follower].self, from: favoritesData)
        } catch {
            favorites = []
            throw PersistenceError.unableToRetrieve
        }
    }
    
    func saveFavorites() throws {
        do {
            let encodedFavorites = try JSONEncoder().encode(favorites)
            userData = encodedFavorites
        } catch {
            throw PersistenceError.unableToFavorite
        }
    }
    
    
}
