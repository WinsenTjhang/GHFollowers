//
//  AvatarImageView.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

struct AvatarImageView: View {
    @State var viewModel = AvatarImageViewModel()
    let url: String
    
    var body: some View {
        viewModel.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
            .onAppear {
                Task {
                    await viewModel.downloadImage(for: url)
                }
            }
    }
}

#Preview {
    AvatarImageView(url: Follower.sampleFollower.avatarUrl)
}
