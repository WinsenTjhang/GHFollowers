//
//  NetworkService.swift
//  GHFollowers
//
//  Created by winsen on 12/04/24.
//

import SwiftUI

class NetworkService {
    var lastResponseHeaders: [AnyHashable: Any]?

    func performRequest<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        self.lastResponseHeaders = (response as? HTTPURLResponse)?.allHeaderFields

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func downloadImage(url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidData
        }
        
        return image
    }
    
}
