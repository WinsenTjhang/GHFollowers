//
//  FollowerCellViewModel.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

@Observable
class FollowerCellViewModel {
    var image: Image = Images.placeholder
    
    func downloadImage(for url: String) async throws {
        image = Image(uiImage: try await NetworkManager.shared.downloadImage(urlString: url))
    }
    
}
