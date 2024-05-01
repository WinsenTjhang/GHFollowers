//
//  MockNetworkManager.swift
//  GHFollowersTests
//
//  Created by winsen on 30/04/24.
//

import SwiftUI
@testable import GHFollowers

class MockNetworkManager: NetworkManagerProtocol {
    
    var shouldGetFollowersSucceed = true
    var shouldGetUserInfoSucceed = true
    var shouldDownloadImageSucceed = true
    
    var mockFollowers: [Follower] = []
    var shouldSimulateHasMoreFollowers = false

    func getFollowers(session: URLSession, of username: String, page: Int) async throws -> ([Follower], Bool) {
        
        if shouldGetFollowersSucceed {
            return (mockFollowers, shouldSimulateHasMoreFollowers)
        } else {
            throw NetworkError.invalidStatusCode(statusCode: 404)
        }
    }

    func getUserInfo(session: URLSession, for username: String) async throws -> User {
        
        if shouldGetUserInfoSucceed {
            return User.sampleUser
        } else {
            throw NetworkError.invalidStatusCode(statusCode: 404)
        }
    }

    func downloadImage(session: URLSession, urlString: String) async throws -> UIImage {
        
        if shouldDownloadImageSucceed {
            if let data = UIImage(named: "placeholderImage")?.pngData() {
               return UIImage(data: data) ?? UIImage()
            } else {
                throw NetworkError.invalidStatusCode(statusCode: 404)
            }
        } else {
            throw NetworkError.invalidStatusCode(statusCode: 404)
        }
    }
}
