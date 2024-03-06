//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

final class PersistenceManager: ObservableObject {
    @AppStorage("userFavorites") private var userData: Data?
    @Published var favorites: [Follower] = []
    
    func add(favorite: Follower) throws {
        guard !favorites.contains(favorite) else {
            throw GFError.alreadyInFavorites
        }
        
        favorites.append(favorite)
        return try self.save(favorites: favorites)
        
    }
    
    func remove(indexSet: IndexSet) throws {
        favorites.remove(atOffsets: indexSet)
        return try self.save(favorites: favorites)
    }
    
    func retrieveFavorites() -> GFError? {
        guard let favoritesData = userData else {
            favorites = []
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            self.favorites = favorites
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    func save(favorites: [Follower]) throws {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            userData = encodedFavorites
        } catch {
            throw GFError.unableToFavorite
        }
    }
    
    
}
