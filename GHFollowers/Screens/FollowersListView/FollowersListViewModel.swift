//
//  FollowersListViewModel.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

class FollowersListViewModel: ObservableObject {
    @Published var isOnFavorite = false
    @Published var followers: [Follower] = []
    @Published var isLoading = true
    var username: String = ""
    var user: Follower = .placeholder
    private var hasMoreFollowers = true
    private var pages = 1
    
    func searchFollowers() {
        Task {
            do {
                followers = try await NetworkManager.shared.getFollowers(of: username, page: pages)
                isLoading = false
//                pages += 1
                if followers.count < 20 { self.hasMoreFollowers = false }
            } catch {
                print(error)
                print("Search followers failed, \(error.localizedDescription)")
            }
        }
    }
    
    
    func getUserInfo() async -> Follower? {
        do {
            let user = try await NetworkManager.shared.getUserInfo(for: username)
            return Follower(login: user.login, avatarUrl: user.avatarUrl)
        } catch {
            print(error)
            print("Get user info failed: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func addToFavorite() {
        do {
            try PersistenceManager.shared.add(favorite: user)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    func removeFavorite() {
        let index = IndexSet(integer: PersistenceManager.shared.favorites.firstIndex(of: user)!)
        
        do {
            try PersistenceManager.shared.remove(indexSet: index)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    func isUserFavorite() {
        Task {
            let _ = PersistenceManager.shared.retrieveFavorites()
            
            guard let user = await getUserInfo() else {return}
            
            self.user = user
            isOnFavorite = PersistenceManager.shared.favorites.contains(user)
        }
    }
    
    func toggleFavorite() {
        if !isOnFavorite {
            addToFavorite()
        } else {
            removeFavorite()
        }
        
        withAnimation(.bouncy) {isOnFavorite.toggle()}
    }
    
    
}
