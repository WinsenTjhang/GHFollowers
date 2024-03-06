//
//  UserInfoViewModel.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

@Observable
class UserInfoViewModel {
    var user: User = .placeholder
    
    func getUserInfo(of username: String) async {
        do {
            user = try await NetworkManager.shared.getUserInfo(for: username)
        } catch {
            print("Error fetching user info:", error)
        }
    }
}
