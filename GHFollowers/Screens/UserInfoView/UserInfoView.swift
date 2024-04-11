//
//  DetailView.swift
//  GHFollowers
//
//  Created by winsen on 26/02/24.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject var viewModel = UserInfoViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var username: String
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(spacing: 32) {
                    if viewModel.user != .placeholder {
                        UserInfoHeaderView(user: $viewModel.user)
                    } else {
                        ProgressView()
                    }
                    
                    Group {
                        UserRepositoryView(user: $viewModel.user)
                        UserFollowersView(user: $viewModel.user)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                        
                    Text("GitHub since \(viewModel.user.createdAt!, formatter: DateFormatter.monthYearDateFormatter)")
                        .font(.caption2)
                }
                .padding()
                
            }
            .onAppear() {
                viewModel.getUserInfo(of: username)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}




#Preview {
    UserInfoView(username: User.sampleUser.login)
}
