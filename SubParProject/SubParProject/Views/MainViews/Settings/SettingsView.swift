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
                
                EditUserInfoView(navigationPath: $navigationPath, viewModel: viewModel, userAuth: userAuth)
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
        .navigationDestination(for: SettingsViewModel.SettingsDestination.self) { destination in
            switch destination {
            case .changePassword:
                ChangePasswordView(navigationPath: $navigationPath, viewModel: viewModel)
            case .applyChanges:
                ApplyChangesView(navigationPath: $navigationPath, viewModel: viewModel)
                    .environmentObject(userAuth)
            case .adminView:
                AdministratorView()
            case .establishmentView:
                EstablishmentsView(isEstablishment: viewModel.isEstablishmemnt, navigationPath: $navigationPath)
            }
        }
    }
}

struct EditUserInfoView : View{
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel : SettingsViewModel
    @StateObject var userAuth : UserAuth
    struct ChangeUsernameView : View {
        @StateObject var viewModel : SettingsViewModel
        var body : some View{
            VStack{
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
                        .textInputAutocapitalization(.never)
                }
            }
        }
    }
    struct ChangePasswordView : View {
        @Binding var navigationPath: NavigationPath
        @StateObject var viewModel : SettingsViewModel
        var body : some View{
            VStack{
                HStack(){
                    Spacer()
                    Text("Change Password")
                        .fontWeight(.bold)
                }
                StyledButton(title: "Change Password", isPrimary: false) {
                    print("NAVIGATE TO CHANGE PASSWORD PAGE")
                    navigationPath.append(SettingsViewModel.SettingsDestination.changePassword)
                }
                .frame(width: 255)
                
                HStack{
                    if(viewModel.newPassword == ""){
                        Text("No New Password")
                            .fontWeight(.bold)
                    }
                    else{
                        Text(viewModel.newPassword)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Text("New Password")
                        .bold()
                }
            }
        }
    }
    struct ChangeEmailView : View {
        @StateObject var viewModel : SettingsViewModel
        var body : some View{
            VStack{
                HStack(){
                    Spacer()
                    Text("Change Email")
                        .fontWeight(.bold)
                }
                .padding(.top, 15)
                HStack{
                    Text(viewModel.golferEmail)
                        .fontWeight(.bold)
                    Spacer()
                    TextField(viewModel.golferEmail, text: $viewModel.newEmail)
                        .frame(width: 165)
                        .textInputAutocapitalization(.never)
                }
            }
        }
    }
    struct ChangePhoneNumberView : View {
        @StateObject var viewModel : SettingsViewModel
        var body : some View{
            VStack{
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
            }
        }
    }
    struct ButtonView : View {
        @Binding var navigationPath: NavigationPath
        @StateObject var viewModel : SettingsViewModel
        var body : some View {
            VStack(spacing: 55) {
                StyledButton(title: "Apply Changes", isPrimary: false) {
                    print("Show user data impending change and ask to type confirm")
                    navigationPath.append(SettingsViewModel.SettingsDestination.applyChanges)
                    //viewModel.applyChanges()
                }
                
                .frame(width: 255)
                StyledButton(title: "Establishments", isPrimary: false) {
                    print("Navigating to Establisments page ")
                    navigationPath.append(SettingsViewModel.SettingsDestination.establishmentView)
                }

                .frame(width: 255)
                
                if(viewModel.isAdministrator){
                    StyledButton(title: "Admin") {
                        //if you are an admin the button will be able to be clicked. otherwise this button cannot be selected
                        print("Navigating to Administration View")
                        navigationPath.append(SettingsViewModel.SettingsDestination.adminView)
                    }
                    .frame(width: 255)
                }
                else{
                    EmptyView()
                }
            }
        }
    }
    var body: some View{
        VStack(){
            ChangeUsernameView(viewModel: viewModel)
                .padding(.top, 15)
            
            ChangePasswordView(navigationPath: $navigationPath, viewModel: viewModel)
                .padding(.top, 15)
            
            ChangeEmailView(viewModel: viewModel)
                .padding(.top, 15)
            
            ChangePhoneNumberView(viewModel: viewModel)
                .padding(.top, 15)
            
            ButtonView(navigationPath: $navigationPath, viewModel: viewModel)
                .padding(.top, 15)
            

        }
        .padding(.top, 30)
        .onAppear(){
            Task{
                await viewModel.getUserInformation(userAuth: userAuth) //load user information into the viewmodel on view startup
            }
            
        }
    }
        
}


           


#Preview{
    SettingsView(navigationPath: .constant(NavigationPath()))
                .environmentObject(UserAuth().log_in_user(userID: 1))
}
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(navigationPath: .constant(NavigationPath()))
//            .environmentObject(UserAuth().log_in_user(userID: 1))
//    }
//}
