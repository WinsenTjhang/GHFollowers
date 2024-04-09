//
//  Constants.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

enum SFSymbols {
    static let search = Image(systemName: "magnifyingglass")
    static let onFavorites = Image(systemName: "heart.fill")
    static let notOnFavorites = Image(systemName: "heart")

    static let location = Image(systemName: "mappin.and.ellipse")
    static let repos = Image(systemName: "folder")
    static let gists = Image(systemName: "text.alignleft")
    static let followers = Image(systemName: "heart")
    static let following = Image(systemName: "person.2")
    
    static let add = Image(systemName: "plus")
}

enum Images {
    static let placeholder = Image("avatar-placeholder")
    static let UIplaceholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = Image("empty-state-logo")
    static let ghLogo = Image("gh-logo")
}
