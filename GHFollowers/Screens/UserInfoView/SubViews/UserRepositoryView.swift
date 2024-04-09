//
//  RepositoryView.swift
//  GHFollowers
//
//  Created by winsen on 29/02/24.
//

import SwiftUI

struct UserRepositoryView: View {
    @Binding var user: User
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        SFSymbols.repos
                        
                        VStack {
                            BodyLabel("Public Repo")
                            BodyLabel("\(user.publicRepos)")
                        }
                        .bold()
                    }
                    
                }
                Spacer()
                
                VStack {
                    HStack(alignment: .firstTextBaseline) {
                        SFSymbols.gists
                        
                        VStack {
                            BodyLabel("Public Gists")
                            BodyLabel("\(user.publicGists)")
                        }
                        .bold()
                    }
                    
                }
            }
            .padding()
            
            Link(destination: URL(string: user.htmlUrl)!) {
                GFButton(title: "GitHub Profile", backgroundColor: .blue)
            }
            
        }
    }
}

#Preview {
    UserRepositoryView(user: .constant(.sampleUser))
}
