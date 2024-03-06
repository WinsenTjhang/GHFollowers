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
                            BodyLabel("Followers")
                            BodyLabel("\(user.followers)")
                        }
                        .bold()
                    }
                }
                Spacer()
                
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        SFSymbols.following
                        
                        VStack {
                            BodyLabel("Following")
                            BodyLabel("\(user.following)")
                        }
                        .bold()
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
