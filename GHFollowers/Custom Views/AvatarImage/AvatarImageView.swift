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
                viewModel.downloadImage(for: url)
            }
            .alert(isPresented: $viewModel.showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
    
}

#Preview {
    AvatarImageView(url: Follower.sampleFollower.avatarUrl)
}
