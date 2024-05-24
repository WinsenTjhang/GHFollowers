//
//  AvatarImageView.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

struct AvatarImageView: View {
    @StateObject var viewModel = AvatarImageViewModel()
    let url: String
    
    var body: some View {
        viewModel.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
            .onAppear {
                Task {
                    do {
                        try await viewModel.downloadImage(for: url)
                    } catch {
                        print("Image download failed")
                        print(error)
                    }
                }
                
            }
    }
    
}

#Preview {
    AvatarImageView(url: Follower.sampleFollower.avatarUrl)
}
