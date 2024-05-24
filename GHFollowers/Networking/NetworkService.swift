//
//  NetworkService.swift
//  GHFollowers
//
//  Created by winsen on 12/04/24.
//

import SwiftUI

class NetworkService {
    
    var lastResponseHeaders: [AnyHashable: Any]?
    
    func performRequest<T: Decodable>(session: URLSession, url: URL, type: T.Type) async throws -> T {
        let (data, response) = try await session.data(from: url)
        self.lastResponseHeaders = (response as? HTTPURLResponse)?.allHeaderFields

        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            throw DecodingError.invalidData
        }
    }
    
    func downloadImage(session: URLSession, url: URL) async throws -> UIImage {
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }

        guard let image = UIImage(data: data) else {
            throw DecodingError.invalidImageData
        }
        
        return image
    }
    
}
