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
            .tint(.black)
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
