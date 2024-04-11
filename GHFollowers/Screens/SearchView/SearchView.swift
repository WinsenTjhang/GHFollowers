//
//  ContentView.swift
//  GHFollowers
//
//  Created by winsen on 24/02/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("gh-logo")
                    .resizable()
                    .frame(width: 170, height: 170)
                
                TextField("Enter Username", text: $viewModel.username)
                    .frame(width: 270)
                    .multilineTextAlignment(.center)
                    .padding(13)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(30)
                
                Spacer()
                
                Button(action: {
                    viewModel.searchFollowers()
                }) {
                    GFButton(title: "Get Followers", backgroundColor: .green)
                }
                
                NavigationLink(destination: FollowersListView(username: viewModel.username),
                               isActive: $viewModel.navigate) {}
                
            }
    
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Sorry"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
}

#Preview {
    SearchView()
}
