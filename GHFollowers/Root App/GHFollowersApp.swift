//
//  GHFollowersApp.swift
//  GHFollowers
//
//  Created by winsen on 24/02/24.
//

import SwiftUI

@main
struct GHFollowersApp: App {
    init() {
            UITabBar.appearance().backgroundColor = UIColor.systemBackground
        }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                SearchView()
                    .tabItem {
                        SFSymbols.search
                        Text("Search")
                    }
                
                FavoritesView()
                    .tabItem {
                        SFSymbols.onFavorites
                        Text("Favorites")
                    }
            }

            
        }
    }
}
