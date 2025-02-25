//
//  SettingsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/10/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth : UserAuth
    @StateObject var viewModel : SettingsViewModel = SettingsViewModel()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue:115/255),
                                                 Color(red: 115/255, green: 175/255, blue:100/255),
                                                 Color(red: 115/255, green: 200/255, blue:200/255),
                                                 Color(red: 0/255, green: 200/255, blue:255/255),
                                                 Color(red:255/255, green:255/255, blue:165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                EditUserInfoView(viewModel: viewModel, userAuth: userAuth)
                Spacer()
                StyledButton(title: "Go Back", isPrimary: true) {
                    navigationPath.removeLast()
                }
                .padding(.leading, 75)
                .padding(.trailing, 75)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
struct DoB_View : View {
    var body: some View {
        EmptyView()
    }
}
struct EditUserInfoView : View{
    @StateObject var viewModel : SettingsViewModel
    @StateObject var userAuth : UserAuth
    var body: some View{
        VStack(){
            HStack(){
                Spacer()
                Text("Change Username")
                    .fontWeight(.bold)
            }
            HStack{
                Text(viewModel.golferUsername)
                    .fontWeight(.bold)
                Spacer()
                TextField(viewModel.golferUsername, text: $viewModel.newUsername)
                    .frame(width: 165)
            }
            .padding(.top, 15)
            
            StyledButton(title: "Change Password", isPrimary: false) {
                print("NAVIGATE TO CHANGE PASSWORD PAGE")
            }
            .padding(.top, 25)
            .frame(width: 255)
            HStack(){
                Spacer()
                Text("Change Email")
                    .fontWeight(.bold)
            }
            .padding(.top, 15)
            HStack{
                Text(viewModel.golferEmail)
                    .fontWeight(.bold)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                Spacer()
                TextField(viewModel.golferEmail, text: $viewModel.newEmail)
                    .frame(width: 165)
            }
            .padding(.top, 15)
            HStack(){
                Spacer()
                Text("Change Phone Number")
                    .fontWeight(.bold)
            }
            .padding(.top, 15)
            HStack{
                Text(viewModel.golferPhoneNumber)
                    .fontWeight(.bold)
                Spacer()
                TextField(viewModel.golferPhoneNumber, text: $viewModel.newPhoneNumber)
                    .frame(width: 165)
            }
            .padding(.top, 15)
            DoB_View()//date picker to upload or change your birthday/ birthdays arent assigned in user signup and can only be added here
            StyledButton(title: "Apply Changes", isPrimary: false) {
                print("Show user data impending change and ask to type confirm")
            }
            .padding(.top, 25)
            .frame(width: 255)
            StyledButton(title: "Establishments", isPrimary: false) {
                print("Navigating to Establisments page ")
            }
            .padding(.top, 55)
            .frame(width: 255)
            Spacer()
            if(viewModel.isAdministrator){
                StyledButton(title: "Admin") {
                    //if you are an admin the button will be able to be clicked. otherwise this button cannot be selected
                    print("Navigating to Administration View")
                }
                .frame(width: 255)
            }
            else{
                EmptyView()
            }
            
            Spacer()

        }
        .padding(.top, 30)
        .onAppear(){
            Task{
                await viewModel.getUserInformation(userAuth: userAuth) //load user information into the viewmodel on view startup
            }
            
        }
    }
        
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
