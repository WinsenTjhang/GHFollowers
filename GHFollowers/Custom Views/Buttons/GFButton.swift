//
//  ButtonView.swift
//  GHFollowers
//
//  Created by winsen on 01/03/24.
//

import SwiftUI

struct GFButton: View {
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .bold()
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    GFButton(title: "Get Followers", backgroundColor: .green)
}
