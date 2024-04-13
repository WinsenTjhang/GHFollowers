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
    
    @MainActor
    func getUserInfo(of username: String) {
        Task {
            do {
                user = try await NetworkManager.shared.getUserInfo(for: username)
            } catch {
                showErrorAlert = true
                errorMessage = error.localizedDescription
                print("Debug Info:", error)
            }
        }
    }
}
