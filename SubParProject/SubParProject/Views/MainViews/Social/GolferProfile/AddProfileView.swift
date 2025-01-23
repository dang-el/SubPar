//
//  AddProfileView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/23/25.
//

import SwiftUI

struct AddProfileView: View {
    @StateObject var viewModel : AddFriendsViewModel
    var golfer: AddFriendsViewModel.GolferResponse
    @Binding var navigationPath : NavigationPath
    @EnvironmentObject var userAuth : UserAuth
    
    var body: some View {
        ZStack{
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
                Text("Golfer: \(golfer.Username)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Add other golfer details as needed
                Spacer()
                VStack{
                    StyledButton(title: "Send Friend Request") {
                        viewModel.addFriend(golfer: golfer, userAuth: userAuth)
                    }
                    
                    .padding(.bottom, 20)
                    StyledButton(title: "Go Back" ,isPrimary: true) {
                        navigationPath.removeLast()
                    }
                    .padding(.top, 20)
                }
                
                .padding(.leading, 75)
                .padding(.trailing, 75)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
        
        
    }
}
struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView(viewModel: AddFriendsViewModel(), golfer: AddFriendsViewModel.GolferResponse(Golfer_ID: 1,Username: "owendangel4096"), navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 2))
    }
}
