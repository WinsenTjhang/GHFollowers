//
//  SearchViewModel.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    
    @Published var username = "shipmadison"
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var navigate = false
    
    private let networkManager: NetworkManagerProtocol
    var completionHandler: (() -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func searchFollowers() {
        Task {
            defer { completionHandler?() }
            
            do {
                let _ = try await networkManager.getFollowers(session: .shared, of: username, page: 1)
                navigate = true
                print(navigate)
            } catch {
                showAlert = true
                alertMessage = "This user does not exist"
                print("Search followers failed, \(error)")
            }
        }
    }
    
}
