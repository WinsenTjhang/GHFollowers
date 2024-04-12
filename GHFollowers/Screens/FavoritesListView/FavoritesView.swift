//
//  FavoritesView.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.favorites, id: \.self) { follower in
                        NavigationLink(destination: FollowersListView(username: follower.login)) {
                            FavoriteCell(user: follower)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.remove(index: indexSet)
                    })
                    
                }
                .navigationTitle("Favorites")
            }
            .onAppear() {
                viewModel.retrieveFavorites()
            }
            
            if viewModel.favorites.isEmpty {
                EmptyStateView(message: viewModel.emptyStateMessage)
            }
            
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

#Preview {
    FavoritesView()
}
