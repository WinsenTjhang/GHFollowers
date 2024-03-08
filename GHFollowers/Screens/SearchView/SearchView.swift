//
//  ContentView.swift
//  GHFollowers
//
//  Created by winsen on 24/02/24.
//

import SwiftUI

struct SearchView: View {
    @State var viewModel = SearchViewModel()
    @State private var username = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigate = false
    
    var body: some View {
        NavigationStack() {
            VStack {
                Spacer()
                Image("gh-logo")
                    .resizable()
                    .frame(width: 170, height: 170)
                
                TextField("Enter Username", text: $username)
                    .frame(width: 270)
                    .multilineTextAlignment(.center)
                    .padding(13)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(30)
                
                Spacer()
                Button(action: {
                    getFollowers()
                }) {
                    GFButton(title: "Get Followers", backgroundColor: .green)
                }
                
            }
            .navigationDestination(isPresented: $navigate) {
                FollowersListView(username: username)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sorry"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func getFollowers() {
        Task {
            do {
                try await viewModel.searchFollowers(of: username)
                navigate = true
            } catch {
                showAlert = true
                alertMessage = "This user does not exist"
                print("Search followers failed, \(error)")
                print("Search followers failed, \(error.localizedDescription)")
            }
        }
    }
    
}

#Preview {
    SearchView()
}
