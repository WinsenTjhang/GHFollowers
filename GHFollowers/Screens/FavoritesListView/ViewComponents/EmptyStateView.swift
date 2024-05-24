//
//  EmptyStateView.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            LargeTitleLabel(message)
                .foregroundColor(.gray)
                .frame(width: 270)
                .multilineTextAlignment(.center)
            
            
            
            HStack {
                Spacer()
                
                Images.emptyStateLogo
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500,
                           height: 500)
                    .padding([.bottom,
                              .trailing],
                             -200)
            }
            Spacer()
            
        }
        .padding()
        
    }
}

#Preview {
    EmptyStateView(message: "No Favorites\n Add one on the follower screen")
}
