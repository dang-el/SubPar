//
//  AddFriendsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/21/25.
//

import SwiftUI


struct AddFriendsView: View {
    @StateObject var viewModel: AddFriendsViewModel = AddFriendsViewModel()
    @Binding var navigationPath: NavigationPath  // Binding to the navigation path
    @EnvironmentObject var userAuth : UserAuth

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
                Text("Add Friends")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                SearchFriendsView(viewModel: viewModel, navigationPath: $navigationPath)
                Spacer()
                StyledButton(title: "Go Back", isPrimary: true) {
                    navigationPath.removeLast() // Go back to the previous view
                }
                .padding(.leading, 125)
                .padding(.trailing, 125)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: AddFriendsViewModel.GolferResponse.self) { golfer in
            AddProfileView(viewModel: viewModel, golfer: golfer, navigationPath: $navigationPath)
                .environmentObject(userAuth)
        
        }
    }
}

struct SearchFriendsView: View {
    @StateObject var viewModel: AddFriendsViewModel
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("Search For Friends")
                .font(.headline)
            TextField("Enter Friends Name", text: $viewModel.friendsName)
                .padding(.leading, 25)
                .autocapitalization(.none)
            AddableFriendsView(viewModel: viewModel, navigationPath: $navigationPath)
        }
        .padding(.top, 25)
    }
}
struct AddableFriendsView: View {
    @StateObject var viewModel: AddFriendsViewModel
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.Golfers, id: \.self) { golfer in
                        StyledButton(title: golfer.Username) {
                            // Push golfer to navigation path
                            navigationPath.append(golfer)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
