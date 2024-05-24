//
//  GFError.swift
//  GHFollowers
//
//  Created by winsen on 28/02/24.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidUsername
    case invalidURL
    case unableToComplete
    case invalidStatusCode(statusCode: Int)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is not valid."
        case .unableToComplete:
            return "Unable to complete the request. Please check your internet connection."
        case .invalidStatusCode(let statusCode):
            return "Invalid response from server. Status Code: \(statusCode)"
        case .invalidUsername:
            return "The username is not valid. Please try a different one."
        
        }
    }
}

enum DecodingError: Error, LocalizedError {
    case invalidData
    case failedToDecodeData
    case invalidImageData
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "The received data is corrupt or invalid."
        case .failedToDecodeData:
            return "Decoding failed"
        case .invalidImageData:
            return "The received image data is corrupt or invalid."
        }
        
    }
}

enum PersistenceError: Error, LocalizedError {
    case alreadyInFavorites
    case unableToFavorite
    case unableToRetrieve

    var errorDescription: String? {
        switch self {
        case .alreadyInFavorites:
            return "This user is already in your favorites."
        case .unableToFavorite:
            return "There was a problem saving to favorites. Please try again."
        case .unableToRetrieve:
            return "Unable to load favorites. Please try again."
        }
    }
}
