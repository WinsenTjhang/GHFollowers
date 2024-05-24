//
//  UserInfoViewModel.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

class UserInfoViewModel: ObservableObject {
    @Published var user: User = .placeholder
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    private let networkManager: NetworkManagerProtocol
    var completionHandler: (() -> Void)?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func getUserInfo(of username: String) {
        Task {
            defer {
                completionHandler?()
            }
            do {
                self.user = try await networkManager.getUserInfo(session: .shared, for: username)
            } catch {
                showErrorAlert = true
                errorMessage = error.localizedDescription
                print("Debug Info:", error)
            }
        }
    }
}
