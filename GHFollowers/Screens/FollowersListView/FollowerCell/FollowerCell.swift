//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

struct FollowerCell: View {
    @StateObject var viewModel = FollowerCellViewModel()
    let follower: Follower
    
    var body: some View {
        VStack {
            viewModel.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            
            BodyLabel(follower.login)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .onAppear() {
            Task {
                do {
                    try await viewModel.downloadImage(for: follower.avatarUrl)
                } catch {
                    print("Image download failed")
                    print(error)
                }
            }
        }
    }
}

#Preview {
    FollowerCell(follower: .sampleFollower)
}
