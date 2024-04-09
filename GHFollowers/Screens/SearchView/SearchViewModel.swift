//
//  SearchViewModel.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

final class SearchViewModel {
    
    func searchFollowers(of username: String) async throws {
        let _ = try await NetworkManager.shared.getFollowers(of: username)
    }
    
}
