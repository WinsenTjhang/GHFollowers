//
//  UserFollowersView.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

struct UserFollowersView: View {
    @Binding var user: User
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        SFSymbols.followers
                        
                        VStack {
                            TitleLabel("Followers")
                            TitleLabel("\(user.followers)")
                        }
                        
                    }
                }
                Spacer()
                
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        SFSymbols.following
                        
                        VStack {
                            TitleLabel("Following")
                            TitleLabel("\(user.following)")
                        }
                    }
                    
                }
            }
            .padding()
                
                if user.followers > 0 {
                    NavigationLink(destination: FollowersListView(username: user.login)) {
                        GFButton(title: "Get Followers", backgroundColor: .green)
                    }
                }
                
        }
    }
}

#Preview {
    UserFollowersView(user: .constant(.sampleUser))
}
