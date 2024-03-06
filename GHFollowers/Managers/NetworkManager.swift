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
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw GFError.invalidResponse
            }
            
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([Follower].self, from: data)
            } else {
                print("HTTP Response Error: \(httpResponse.statusCode)")
                throw GFError.invalidResponse
            }
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
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw GFError.invalidResponse
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
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw GFError.invalidData
        }
        
        return image
    }
    
}
