//
//  AvatarImageViewModel.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

final class AvatarImageViewModel: ObservableObject {
    @Published var image: Image = Images.placeholder
    
    func downloadImage(for url: String) {
        Task {
            do {
                image = Image(uiImage: try await NetworkManager.shared.downloadImage(urlString: url))
            } catch {
                print("Error downloading image:", error)
            }
        }
        
    }
}
