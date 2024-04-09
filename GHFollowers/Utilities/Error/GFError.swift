//
//  GFError.swift
//  GHFollowers
//
//  Created by winsen on 28/02/24.
//

import Foundation

enum GFError: Error{
    case invalidUsername
    case invalidURL
    case unableToComplete
    case invalidResponse(statusCode: Int)
    case invalidData
    case alreadyInFavorites
    case unableToFavorite
}
