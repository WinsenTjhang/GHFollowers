//
//  NetworkControllers.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//
import SwiftUI
import Foundation


final class NetworkManager {
    private let networkService = NetworkService()
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
    func getFollowers(of username: String, page: Int) async throws -> ([Follower], Bool) {
        let endpoint = baseURL + username + "/followers?per_page=20&page=\(page)"
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidUsername }
        
        let followers: [Follower] = try await networkService.performRequest(url: url, type: [Follower].self)
        
        let hasMorePages = try await checkForAdditionalPages()
        
        return (followers, hasMorePages)
    }
    
    func checkForAdditionalPages() async throws -> Bool {
        guard let headers = networkService.lastResponseHeaders,
              let linkHeader = headers["Link"] as? String else { return false }
        
        return linkHeader.components(separatedBy: ", ")
            .contains(where: { $0.contains("rel=\"next\"") })
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + username
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidUsername }
        
        return try await networkService.performRequest(url: url, type: User.self)
    }
    
    func downloadImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        return try await networkService.downloadImage(url: url)
    }
    
}
