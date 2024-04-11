//
//  NetworkControllers.swift
//  GHFollowers
//
//  Created by winsen on 25/02/24.
//
import SwiftUI
import Foundation


final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
    func getFollowers(of username: String, page: Int) async throws -> ([Follower], Bool) {
        let endpoint = baseURL + username + "/followers?per_page=20&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let httpResponse = response as? HTTPURLResponse
        
        
        guard httpResponse?.statusCode == 200 else {
            throw GFError.invalidResponse(statusCode: httpResponse!.statusCode)
        }
        
        var pagesRemaining = false
        
        if let linkHeader = httpResponse!.allHeaderFields["Link"] as? String {
            pagesRemaining = isPagesRemaining(from: linkHeader)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode([Follower].self, from: data)
            return (decodedData, pagesRemaining)
        } catch {
            throw GFError.invalidData
        }
        
        
        func isPagesRemaining(from linkHeader: String) -> Bool {
            let links = linkHeader.components(separatedBy: ", ")
            for link in links where link.contains("rel=\"next\"") {
               return true
            }
            return false
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
