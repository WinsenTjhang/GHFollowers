//
//  NetworkControllers.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//
import SwiftUI
import Foundation

protocol NetworkManagerProtocol {
    
    func getFollowers(session: URLSession, of username: String, page: Int) async throws -> ([Follower], Bool)
    func getUserInfo(session: URLSession, for username: String) async throws -> User
    func downloadImage(session: URLSession, urlString: String) async throws -> UIImage
}

final class NetworkManager: NetworkManagerProtocol {
    
    let networkService = NetworkService()
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
    func getFollowers(session: URLSession = .shared, of username: String, page: Int) async throws -> ([Follower], Bool) {
        let endpoint = baseURL + username + "/followers?per_page=20&page=\(page)"
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidURL }
        
        let followers: [Follower] = try await networkService.performRequest(session: session, url: url, type: [Follower].self)
        let hasMorePages = checkForAdditionalPages()
        
        return (followers, hasMorePages)
        
    }
    
    func checkForAdditionalPages() -> Bool {
        guard let headers = networkService.lastResponseHeaders,
              let linkHeader = headers["Link"] as? String else { return false }
        
        return linkHeader.components(separatedBy: ", ")
            .contains(where: { $0.contains("rel=\"next\"") })
        
    }
    
    func getUserInfo(session: URLSession = .shared, for username: String) async throws -> User {
        let endpoint = baseURL + username
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidUsername }
        
        return try await networkService.performRequest(session: session, url: url, type: User.self)
        
    }
    
    func downloadImage(session: URLSession = .shared, urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        return try await networkService.downloadImage(session: session, url: url)
        
    }
    
}
