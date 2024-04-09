//
//  FollowersView.swift
//  GHFollowers
//
//  Created by winsen on 26/02/24.
//

import SwiftUI

struct FollowersListView: View {
    @Environment(PersistenceManager.self) var persistenceManager: PersistenceManager
    @State var viewModel = FollowersListViewModel()
    @State var isOnFavorite = false
    var username: String
    
    private let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: threeColumnGrid){
                    ForEach(viewModel.followers, id: \.self) { follower in
                        NavigationLink(destination: UserInfoView(username: follower.login)) {
                            FollowerCell(follower: follower)
                        }
                    }
                }
                .navigationTitle("\(username)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    favoriteButton
                }
                .onAppear() {
                    Task {
                        await viewModel.searchFollowers(of: username)
                        isOnFavorite = await viewModel.isUserFavorite(username: username, persistenceManager: persistenceManager)
                    }
                }
                
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if viewModel.followers.isEmpty && !viewModel.isLoading{
                EmptyStateView(message: "This user doesn't have any followers")
            }
            
        }
        
    }
    
}

private extension FollowersListView {
    var favoriteButton: some View {
        Button(action: {
            if !isOnFavorite {
                viewModel.addToFavorite(persistenceManager: persistenceManager)
            } else {
                viewModel.removeFavorite(persistenceManager: persistenceManager)
            }
            
            withAnimation(.bouncy) { isOnFavorite.toggle() }
            
        }) {
            isOnFavorite ? SFSymbols.onFavorites : SFSymbols.notOnFavorites
        }
        .disabled(viewModel.isLoading)
    }
}


#Preview {
    FollowersListView(username: "shipmadison")
}
