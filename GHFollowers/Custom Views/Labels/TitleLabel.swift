//
//  TitleLabel.swift
//  GHFollowers
//
//  Created by winsen on 05/03/24.
//

import SwiftUI

struct TitleLabel: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.headline)
            .minimumScaleFactor(0.75)
    }
}

#Preview {
    TitleLabel("TitleLabel")
}
