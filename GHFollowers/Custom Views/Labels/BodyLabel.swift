//
//  BodyLabel.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

struct BodyLabel: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(Color.primary)
            .minimumScaleFactor(0.9)
    }
}

#Preview {
    BodyLabel("BodyLabel")
}
