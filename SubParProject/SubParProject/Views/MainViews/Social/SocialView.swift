//
//  SocialView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//
import SwiftUI
enum SocialNavigationDestination: Hashable {
    case addFriends
    case addedMe
}

struct SocialView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth: UserAuth

    var body: some View {
        ZStack {
            // Background Gradient
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
                // Header
                Text("Social")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()
                FriendsView()
                Spacer()
                HStack(spacing: 30) {
                    StyledButton(title: "Add Friends") {
                        // Navigate to Add Friends View
                        navigationPath.append(SocialNavigationDestination.addFriends)
                    }
                    .padding(.leading, 30)
                    StyledButton(title: "Added Me") {
                        // Navigate to Added Me View
                        navigationPath.append(SocialNavigationDestination.addedMe)
                    }
                    .padding(.trailing, 30)
                }
                .padding(.bottom, 20)

                // Go Back Button
                StyledButton(title: "Go Back", isPrimary: true) {
                    navigationPath.removeLast() // Go back to the previous view
                }
                .padding(.leading, 125)
                .padding(.trailing, 125)

            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(for: SocialNavigationDestination.self) { destination in
            // Navigate based on enum case
            switch destination {
            case .addFriends:
                AddFriendsView(navigationPath: $navigationPath)
                    .environmentObject(userAuth)
            case .addedMe:
                AddedMeView(navigationPath: $navigationPath)
                    .environmentObject(userAuth)
            }
        }
    }
}

struct FriendsView: View {
    @StateObject private var viewModel = SocialViewModel() // Initialize the ViewModel
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack {
            if viewModel.loading {
                // Loading indicator while fetching friends
                ProgressView("Loading friends...")
                    .padding()
            } else if viewModel.Friends.isEmpty {
                // Message for no friends
                Text("You have no friends yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Friends list in a scroll view
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.Friends, id: \.Golfer_ID) { friend in
                            FriendCard(friend: friend)
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            Task {
                do {
                    try await viewModel.getFriends(userAuth: userAuth)
                } catch {
                    print("Failed to fetch friends: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct FriendCard: View {
    let friend: SocialViewModel.GolferResponse
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(friend.Username.prefix(1))
                        .font(.headline)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading) {
                Text(friend.Username)
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Golfer ID: \(friend.Golfer_ID)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}




struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
