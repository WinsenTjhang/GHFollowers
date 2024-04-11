//
//  UserInfoHeaderView.swift
//  GHFollowers
//
//  Created by winsen on 28/02/24.
//

import SwiftUI

struct UserInfoHeaderView: View {
    @Binding var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AvatarImageView(url: user.avatarUrl)
                    .frame(width: 90, height: 90)
                
                VStack(alignment: .leading) {
                    LargeTitleLabel("\(user.login)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Group {
                        BodyLabel("\(user.name ?? "")")
                        
                        HStack {
                            SFSymbols.location
                            BodyLabel("\(user.location ?? "No Location")")
                        }
                    }
                    
                }
                .foregroundColor(.secondary)
                
                Spacer()
            }
            
            if let bio = user.bio {
                BodyLabel("\(bio)")
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
            }
            
        }
        .padding()
        
    }
}

#Preview {
    UserInfoHeaderView(user: .constant(.sampleUser))
}
