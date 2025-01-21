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
            case .addedMe:
                AddedMeView(navigationPath: $navigationPath)
            }
        }
    }
}





struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
