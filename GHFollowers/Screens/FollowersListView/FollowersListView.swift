//
//  FollowersView.swift
//  GHFollowers
//
//  Created by winsen on 26/02/24.
//

import SwiftUI

struct FollowersListView: View {
    @StateObject var viewModel = FollowersListViewModel()
    var username: String
    
    var body: some View {
        let threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
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
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            
            let _ = print(viewModel.followers.isEmpty)
            let _ = print(viewModel.isLoading)
            let _ = print(viewModel.followers)
            if viewModel.followers.isEmpty && !viewModel.isLoading{
                EmptyStateView(message: "This user doesn't have any followers")
            }
            
        }
        .onAppear() {
            viewModel.username = username
            viewModel.searchFollowers()
            viewModel.isUserFavorite()
        }
        
    }
    
}

private extension FollowersListView {
    var favoriteButton: some View {
        Button(action: {viewModel.toggleFavorite()}) {
            viewModel.isOnFavorite ? SFSymbols.onFavorites : SFSymbols.notOnFavorites
        }
        .disabled(viewModel.isLoading)
    }
}


#Preview {
    FollowersListView(username: "shipmadison")
}
