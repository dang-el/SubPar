//
//  AddedMe.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/21/25.
//

import SwiftUI


struct AddedMeView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth: UserAuth
    @StateObject var viewModel: AddedMeViewModel = AddedMeViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 115/255, green: 185/255, blue: 115/255),
                Color(red: 115/255, green: 175/255, blue: 100/255),
                Color(red: 115/255, green: 200/255, blue: 200/255),
                Color(red: 0/255, green: 200/255, blue: 255/255),
                Color(red: 255/255, green: 255/255, blue: 165/255)
            ]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Added Me")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                
                ScrollView {
                    VStack {
                        
                        if viewModel.loading {
                            // Show a loading indicator
                            HStack {
                                Text("Loading friend requests...")
                                    .foregroundColor(.gray)
                                    .padding()
                                ProgressView()
                            }
                        } else if viewModel.FriendRequests.isEmpty {
                            // Show a message if there are no friend requests
                            Text("No friend requests yet.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // Display the actual friend requests
                            ForEach(viewModel.FriendRequests, id: \.Golfer_ID) { golfer in
                                IncomingFriendRequest(viewModel: viewModel, friendRequesting: golfer)
                                    .environmentObject(userAuth)
                                    .padding(10)
                            }
                        }
                    }
                }
                
                Spacer()
                
                StyledButton(title: "Go Back", isPrimary: true) {
                    navigationPath.removeLast()
                }
                .padding(.horizontal, 75)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Call the fetchData function when the view appears
            Task {
                do {
                    try await viewModel.getRequests(userAuth: userAuth)
                } catch {
                    print("Failed to fetch friend requests: \(error.localizedDescription)")
                }
            }
        }
    }
}
struct IncomingFriendRequest: View {
    @StateObject var viewModel : AddedMeViewModel
    var friendRequesting: AddedMeViewModel.GolferResponse
    @EnvironmentObject var userAuth : UserAuth
    var body: some View {
        HStack {
            // Placeholder for a profile image
            Circle()
                .fill(Color.cyan)
                .frame(width: 50, height: 50)
            
                .overlay(
                    Text(friendRequesting.Username.prefix(1)) // Display the first letter of the friend's name
                        .font(.headline)
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2) // Add a white border
                )
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2) // Add a subtle shadow
            
            
            // Friend name and optional subtitle
            VStack(alignment: .leading) {
                Text(friendRequesting.Username)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Sent you a friend request")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            // Action buttons
            HStack {
                Button(action: {
                    Task{
                        try await viewModel.acceptFriendRequest(userAuth: userAuth, friendRequesting: friendRequesting)
                    }
                    
                }) {
                    Text("Accept")
                        .frame(minWidth: 70) // Set a minimum width
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    Task{
                        try await viewModel.declineFriendRequest(userAuth: userAuth , friendRequesting: friendRequesting)
                    }
                    
                }) {
                    Text("Decline")
                        .frame(minWidth: 70) // Set a minimum width
                        .padding(.vertical, 8)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}


struct AddedMe_Previews: PreviewProvider {
    static var previews: some View {
        AddedMeView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
