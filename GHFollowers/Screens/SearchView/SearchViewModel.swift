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
    
    func searchFollowers() {
        Task {
            do {
                let _ = try await NetworkManager.shared.getFollowers(of: username, page: 1)
                navigate = true
            } catch {
                showAlert = true
                alertMessage = "This user does not exist"
                print("Search followers failed, \(error)")
            }
        }
    }
    
}
