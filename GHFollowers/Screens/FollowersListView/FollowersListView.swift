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
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(lastFollower: follower)
                                }
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
            
            if viewModel.followers.isEmpty && !viewModel.isLoading{
                EmptyStateView(message: "This user doesn't have any followers")
            }
            
        }
        .onAppear() {
            viewModel.username = username
            viewModel.followers = []
            viewModel.currentPage = 1
            viewModel.fetchFollowers()
            viewModel.isUserFavorite()
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
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
