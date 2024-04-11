//
//  LargeTitleLabel.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

struct LargeTitleLabel: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title)
            .bold()
            .foregroundColor(Color.primary)
            .minimumScaleFactor(0.75)
    }
}

#Preview {
    LargeTitleLabel("LargeTitleLabel")
}
