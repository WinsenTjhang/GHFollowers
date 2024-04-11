//
//  FollowerCellViewModel.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

class FollowerCellViewModel: ObservableObject {
    @Published var image: Image = Images.placeholder
    
    func downloadImage(for url: String) {
        Task {
            do {
                image = Image(uiImage: try await NetworkManager.shared.downloadImage(urlString: url))
            } catch {
                print("Image download failed")
                print(error)
            }
        }
    }
    
}
