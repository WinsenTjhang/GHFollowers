//
//  NetworkControllers.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//
import SwiftUI
import Foundation

@Observable
final class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com/users/"
    
    func getFollowers(of username: String) async throws -> [Follower] {
        let endpoint = baseURL + username + "/followers?per_page=30"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let httpResponseCode = (response as? HTTPURLResponse)?.statusCode
        
        guard httpResponseCode == 200 else {
            throw GFError.invalidResponse(statusCode: httpResponseCode!)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Follower].self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + username
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let httpResponseCode = (response as? HTTPURLResponse)?.statusCode
        
        guard httpResponseCode == 200 else {
            throw GFError.invalidResponse(statusCode: httpResponseCode!)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.invalidData
        }
    }
                
    func downloadImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            print(urlString)
            throw GFError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        let httpResponseCode = (response as? HTTPURLResponse)?.statusCode
        
        guard httpResponseCode == 200 else {
            throw GFError.invalidResponse(statusCode: httpResponseCode!)
        }
        
        guard let image = UIImage(data: data) else {
            throw GFError.invalidData
        }
        
        return image
    }
    
}
