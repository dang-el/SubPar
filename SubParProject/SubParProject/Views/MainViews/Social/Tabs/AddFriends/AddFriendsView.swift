//
//  AddFriendsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/21/25.
//

import SwiftUI


struct AddFriendsView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth: UserAuth
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
                Text("Add Friends")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                StyledButton(title: "Go Back", isPrimary: true ){
                    navigationPath.removeLast()
                }
                .padding(.leading, 75)
                .padding(.trailing, 75)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
