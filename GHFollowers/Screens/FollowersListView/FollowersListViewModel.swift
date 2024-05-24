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
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    var username: String = ""
    var user: Follower = .placeholder
    var hasMoreFollowers = false
    var currentPage = 1
    
    private let networkManager: NetworkManagerProtocol
    private let persistenceManager: PersistenceManagerProtocol
    var completionHandler: (() -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared, persistenceManager: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.networkManager = networkManager
        self.persistenceManager = persistenceManager
    }
    
    @MainActor
    func fetchFollowers() {
        Task {
            guard !isLoading else { return } 
            
            isLoading = true
            defer {
                isLoading = false
                completionHandler?()
            }
            
            do {
                let (followers, hasMorePages) = try await networkManager.getFollowers(session: .shared, of: username, page: currentPage)
                self.followers.append(contentsOf: followers)
                self.hasMoreFollowers = hasMorePages
                if hasMoreFollowers {
                    currentPage += 1
                }
            } catch {
                showErrorAlert = true
                errorMessage = error.localizedDescription
                print("Debug Info:", error)
            }
        }
    }
    
    @MainActor
    func loadMoreIfNeeded(lastFollower currentFollower: Follower) {
        if currentFollower == followers.last && hasMoreFollowers {
            fetchFollowers()
        }
    }
    
    @MainActor
    func getUserInfo() async -> Follower? {
        defer {
            completionHandler?()
        }
        
        do {
            let user = try await networkManager.getUserInfo(session: .shared, for: username)
            return Follower(login: user.login, avatarUrl: user.avatarUrl)
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
        
        return nil
    }
    
    
    func addToFavorite() {
        do {
            try persistenceManager.add(favorite: user)
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
    
    
    func removeFavorite() {
        let index = IndexSet(integer: persistenceManager.favorites.firstIndex(of: user)!)
        
        do {
            try persistenceManager.remove(indexSet: index)
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
            print("Debug Info:", error)
        }
    }
    
    
    @MainActor
    func isUserFavorite() {
        Task {
            defer {
                completionHandler?()
            }
            
            do {
                let _ = try persistenceManager.retrieveFavorites()
                guard let user = await getUserInfo() else {return}
                
                self.user = user
                isOnFavorite = persistenceManager.favorites.contains(user)
            } catch {
                showErrorAlert = true
                errorMessage = error.localizedDescription
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
