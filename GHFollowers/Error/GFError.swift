//
//  GFError.swift
//  GHFollowers
//
//  Created by winsen on 28/02/24.
//

import Foundation

enum GFError: String, Error{
    case invalidUsername
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    case unableToFavorite
    case alreadyInFavorites
}
