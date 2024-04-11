//
//  UserInfoViewModel.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

class UserInfoViewModel: ObservableObject {
    @Published var user: User = .placeholder
    
    func getUserInfo(of username: String) {
        Task {
            do {
                user = try await NetworkManager.shared.getUserInfo(for: username)
            } catch {
                print("Error fetching user info:", error)
            }
        }
    }
}
