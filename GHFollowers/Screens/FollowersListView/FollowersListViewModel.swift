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
    @Published var isLoading = false
    @Published var showAlert = false
    
    private var username: String = ""
    private var user: Follower = .placeholder
    private var hasMoreFollowers = true
    private var currentPage = 1
    
    func searchFollowers() {
        guard !isLoading else { return } // Avoid redundant network requests
        
        isLoading = true
        defer { isLoading = false } // Ensure loading state is reset
        
        Task {
            do {
                let (followers, pagesRemaining) = try await NetworkManager.shared.getFollowers(of: username, page: currentPage)
                self.followers.append(contentsOf: followers)
                self.hasMoreFollowers = pagesRemaining
                if hasMoreFollowers {
                    currentPage += 1
                }
            } catch {
                print(error.localizedDescription)
                print("Debug Info:", error)
            }
        }
    }
    
    func loadMoreIfNeeded(lastFollower currentFollower: Follower) {
        if currentFollower == followers.last && hasMoreFollowers {
            searchFollowers()
        }
    }
    
    
    func getUserInfo() async -> Follower? {
        do {
            let user = try await NetworkManager.shared.getUserInfo(for: username)
            return Follower(login: user.login, avatarUrl: user.avatarUrl)
        } catch {
            print(error.localizedDescription)
            print("Debug Info:", error)
        }
        
        return nil
    }
    
    
    func addToFavorite() {
        do {
            try PersistenceManager.shared.add(favorite: user)
        } catch {
            print(error.localizedDescription)
            print("Debug Info:", error)
        }
    }
    
    
    func removeFavorite() {
        let index = IndexSet(integer: PersistenceManager.shared.favorites.firstIndex(of: user)!)
        
        do {
            try PersistenceManager.shared.remove(indexSet: index)
        } catch {
            print(error.localizedDescription)
            print("Debug Info:", error)
        }
    }
    
    
    func isUserFavorite() {
        Task {
            do {
                let _ = try PersistenceManager.shared.retrieveFavorites()
                guard let user = await getUserInfo() else {return}
                
                self.user = user
                isOnFavorite = PersistenceManager.shared.favorites.contains(user)
            } catch {
                print(error.localizedDescription)
                print("Debug Info:", error)
            }
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
