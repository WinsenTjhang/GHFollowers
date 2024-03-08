//
//  FavoritesView.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(PersistenceManager.self) var persistenceManager: PersistenceManager
    @State var viewModel = FavoritesViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(viewModel.favorites, id: \.self) { follower in
                        NavigationLink(destination: FollowersListView(username: follower.login)) {
                            FavoriteCell(user: follower)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.remove(index: indexSet, persistenceManager: persistenceManager)
                    })
                    
                }
                .navigationTitle("Favorites")
            }
            .onAppear() {
                viewModel.retrieveFavorites(persistenceManager: persistenceManager)
            }
            
            if viewModel.favorites.isEmpty {
                EmptyStateView(message: FavoritesViewModel.emptyStateMessage)
                
            }
            
        }
            
    }
}

#Preview {
    FavoritesView()
}
