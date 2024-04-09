//
//  FollowersListViewModel.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

@Observable
class FollowersListViewModel {
    var followers: [Follower] = []
    var user: Follower = .placeholder
    var isLoading = true
    
    func searchFollowers(of username: String) async {
        do {
            followers = try await NetworkManager.shared.getFollowers(of: username)
            isLoading = false
        } catch {
            print(error)
            print("Search followers failed, \(error.localizedDescription)")
        }
    }
    
    
    func getUserInfo(for username: String) async -> Follower? {
        do {
            let user = try await NetworkManager.shared.getUserInfo(for: username)
            return Follower(login: user.login, avatarUrl: user.avatarUrl)
        } catch {
            print(error)
            print("Get user info failed: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func addToFavorite(persistenceManager: PersistenceManager) {
        do {
            try persistenceManager.add(favorite: user)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    func removeFavorite(persistenceManager: PersistenceManager) {
        let index = IndexSet(integer: persistenceManager.favorites.firstIndex(of: user)!)
        
        do {
            try persistenceManager.remove(indexSet: index)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    func isUserFavorite(username: String, persistenceManager: PersistenceManager) async -> Bool {
        let _ = persistenceManager.retrieveFavorites()
        
        guard let user = await getUserInfo(for: username) else {
            return false
        }
        
        self.user = user
        return persistenceManager.favorites.contains(user)
    }
    
    
}
