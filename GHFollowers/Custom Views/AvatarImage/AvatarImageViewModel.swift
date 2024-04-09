//
//  AvatarImageViewModel.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

@Observable
final class AvatarImageViewModel {
    var image: Image = Images.placeholder
    
    func downloadImage(for url: String) async {
        do {
            image = Image(uiImage: try await NetworkManager.shared.downloadImage(urlString: url))
        } catch {
            print("Error downloading image:", error)
        }
        
    }
}
