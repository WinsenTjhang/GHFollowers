//
//  GHFollowersApp.swift
//  GHFollowers
//
//  Created by winsen on 24/02/24.
//

import SwiftUI

@main
struct GHFollowersApp: App {
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
            
        }
    }
}
