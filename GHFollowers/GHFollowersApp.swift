//
//  GHFollowersApp.swift
//  GHFollowers
//
//  Created by winsen on 24/02/24.
//

import SwiftUI

@main
struct GHFollowersApp: App {
    @State var persistenceManager = PersistenceManager()
    @State var networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
                    
            }
            .tint(.yellow)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
                appearance.backgroundColor = UIColor(Color.clear.opacity(0.1))
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            
        }
        .environment(persistenceManager)
    }
}
