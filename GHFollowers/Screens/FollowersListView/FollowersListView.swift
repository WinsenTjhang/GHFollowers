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
    @State var user: Follower = .placeholder
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
                    viewModel.username = username
                    Task {
                        isOnFavorite = await viewModel.isUserFavorite(persistenceManager: persistenceManager)
                    }
                }
                .onReceive(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Publisher@*/NotificationCenter.default.publisher(for: .NSCalendarDayChanged)/*@END_MENU_TOKEN@*/, perform: { _ in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=code@*/ /*@END_MENU_TOKEN@*/
                })
                
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
                viewModel.add(persistenceManager: persistenceManager)
                isOnFavorite = true
            } else {
                viewModel.remove(persistenceManager: persistenceManager)
                isOnFavorite = false
            }
            
        }) {
            if isOnFavorite {
                SFSymbols.onFavorites
            } else {
                SFSymbols.notOnFavorites
            }
            
        }
    }
}
    
    #Preview {
        FollowersListView(username: "shipmadison")
    }
