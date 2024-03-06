//
//  User.swift
//  GHFollowers
//
//  Created by winsen on 26/02/24.
//

import Foundation
import SwiftUI

struct User: Codable, Hashable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date?
}


extension User {
    static let placeholder: User =
        User(login: "",
             avatarUrl: "",
             name: "",
             location: nil,
             bio: nil,
             publicRepos: 0,
             publicGists: 0,
             htmlUrl: "www.github.com",
             following: 0,
             followers: 0,
             createdAt: Date())
    
    static let sampleUser: User =
        User(login: "wStockhausen",
             avatarUrl: "https://avatars.githubusercontent.com/u/10645516?v=4",
             name: "John Appleseed",
             location: "Cupertino, CA",
             bio: "Swift addict",
             publicRepos: 9,
             publicGists: 41,
             htmlUrl: "https://github.com",
             following: 1984,
             followers: 270,
             createdAt: Date())
}
