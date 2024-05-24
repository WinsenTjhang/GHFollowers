//
//  FollowerCellViewModel.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

class FollowerCellViewModel: ObservableObject {
    @Published var image: Image = Images.placeholder
    
    private let networkManager: NetworkManagerProtocol
    var completionHandler: (() -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func downloadImage(for url: String) async throws {
        defer {
            completionHandler?()
        }
        
        image = Image(uiImage: try await networkManager.downloadImage(session: .shared, urlString: url))
    }
    
}
