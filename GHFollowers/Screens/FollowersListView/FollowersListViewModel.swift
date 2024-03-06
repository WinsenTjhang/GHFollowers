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
    var username: String = "" {
        didSet {
            Task {
                await searchFollowers()
            }
        }
    }
    
    
    func searchFollowers() async {
        do {
            followers = try await NetworkManager.shared.getFollowers(of: username)
            isLoading = false
        } catch {
            print("Search followers failed: \(error.localizedDescription)")
        }
    }
    
    
    func getUserInfo(for username: String) async -> Follower? {
        do {
            let user = try await NetworkManager.shared.getUserInfo(for: username)
            return Follower(login: user.login, avatarUrl: user.avatarUrl)
        } catch {
            print("Get user info failed: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func add(persistenceManager: PersistenceManager) {
        do {
            try persistenceManager.add(favorite: user)
        } catch {
            print("Adding favorite failed: \(error.localizedDescription)")
        }
        
    }
    
    
    func remove(persistenceManager: PersistenceManager) {
        let index = IndexSet(integer: persistenceManager.favorites.firstIndex(of: user)!)
        
        do {
            try persistenceManager.remove(indexSet: index)
        } catch {
            print("Remove function error: \(error.localizedDescription)")
        }
    }
    
    
    func isUserFavorite(persistenceManager: PersistenceManager) async -> Bool {
        let _ = persistenceManager.retrieveFavorites()
        
        guard let user = await getUserInfo(for: username) else {
            return false
        }
        
        self.user = user
        
        return persistenceManager.favorites.contains(user)
    }
    
    
}
