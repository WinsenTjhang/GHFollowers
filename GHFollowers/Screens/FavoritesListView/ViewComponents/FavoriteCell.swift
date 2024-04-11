//
//  FavoriteCell.swift
//  GHFollowers
//
//  Created by winsen on 04/03/24.
//

import SwiftUI

struct FavoriteCell: View {
    var user: Follower
    
    var body: some View {
        HStack {
            AvatarImageView(url: user.avatarUrl)
                .frame(width: 60, height: 60)
            LargeTitleLabel("\(user.login)")
                .foregroundColor(.black)
                .padding(.horizontal)
            Spacer()
        }
        
    }
}

#Preview {
    FavoriteCell(user: Follower.sampleFollower)
}
