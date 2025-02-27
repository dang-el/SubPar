//
//  ApplyChangesView.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/25/25.
//

import SwiftUI

struct ApplyChangesView : View{
    @Binding var navigationPath : NavigationPath
    @StateObject var viewModel : SettingsViewModel
    @EnvironmentObject var userAuth : UserAuth
    
    var body : some View {
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
            VStack{
                Text("Apply Changes")
                    .font(.largeTitle)
                    .bold()
                if(viewModel.applyChangesResponse != ""){
                    Text(viewModel.applyChangesResponse)
                        .bold()
                        
                        
                }
                else{
                    EmptyView()
                }
                Spacer()
                
                if(viewModel.wasFetched){
                    ChangesView(viewModel: viewModel).environmentObject(userAuth)
                }
                else{
                    Text("Changes Unable to be Applied. Please Try again. Sorry.")
                }
                
                Spacer()
                StyledButton(title: "Go Back", isPrimary: true) {
                    viewModel.applyChangesResponse = ""
                    navigationPath.removeLast()
                }
                .frame(width: 255)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
    struct ChangesView : View {
        @EnvironmentObject var userAuth : UserAuth
        @StateObject var viewModel : SettingsViewModel
        var body : some View {
            
            VStack(spacing: 50) {
                
                
                UsernameChangesView(viewModel: viewModel)
                
                PasswordChangesView(viewModel: viewModel)
                
                EmailChangesView(viewModel: viewModel)
                
                PhoneNumberChangesView(viewModel: viewModel)
                
                StyledButton(title: "Submit Changes for Review") {
                    Task{
                        await viewModel.applyChanges(userAuth: userAuth)
                    }
                    
                }
                .frame(width: 255)
            }
            
            
        }
        struct EmailChangesView : View {
            
            struct NoEmailChangesView : View { //maybe i want to elaborate this. maybe i dont. maybe its good enough
                var body : some View{
                    Text("No Email Changes")
                        .bold()
                }
            }
            
            @StateObject var viewModel : SettingsViewModel
            var body : some View {
                VStack{
                    Text("Email Changes")
                        .font(.headline)
                        .bold()
                    if(viewModel.newEmail == ""){
                        //no username changes
                        NoEmailChangesView()
                        
                    }
                    else{
                        //we need to display the change that the username needs to be updated
                        VStack{
                            HStack{
                                Text("Old Email")
                                    .font(.callout)
                                Spacer()
                                Text("New Email")
                                    .font(.callout)
                                
                            }
                            HStack{
                                //because we have a filled "new username" we should display the old and new usernames for the user to see made changes and approve of them
                                Text(viewModel.golferEmail)
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Text(viewModel.newEmail)
                                    .font(.title3)
                                    .bold()
                            }
                            
                        }
                        .padding()
                        .italic()
                    
                        
                    }
                }
            }
        }
        struct PhoneNumberChangesView : View {
            
            struct NoPhoneNumberChangesView : View { //maybe i want to elaborate this. maybe i dont. maybe its good enough
                var body : some View{
                    Text("No Phone Number Changes")
                        .bold()
                }
            }
            
            @StateObject var viewModel : SettingsViewModel
            var body : some View {
                VStack{
                    Text("Phone Number Changes")
                        .font(.headline)
                        .bold()
                    if(viewModel.newPhoneNumber == ""){
                        //no username changes
                        NoPhoneNumberChangesView()
                        
                    }
                    else{
                        //we need to display the change that the username needs to be updated
                        VStack{
                            HStack{
                                Text("Old Phone Number")
                                    .font(.callout)
                                Spacer()
                                Text("New Phone Number")
                                    .font(.callout)
                                
                            }
                            HStack{
                                //because we have a filled "new username" we should display the old and new usernames for the user to see made changes and approve of them
                                Text(viewModel.golferPhoneNumber)
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Text(viewModel.newPhoneNumber)
                                    .font(.title3)
                                    .bold()
                            }
                            
                        }
                        .padding()
                        .italic()
                    
                        
                    }
                }
            }
        }
        struct PasswordChangesView : View {
            struct NoPasswordChangesView : View { //maybe i want to elaborate this. maybe i dont. maybe its good enough
                var body : some View{
                    Text("No Password Changes")
                        .bold()
                }
            }
            @StateObject var viewModel : SettingsViewModel
            var body: some View {
                VStack{
                    Text("Password Changes")
                        .font(.headline)
                        .bold()
                    if(viewModel.newPassword == "" ){
                        NoPasswordChangesView()
                    }
                    else{
                        VStack{
                            Text("New Password")
                                .font(.callout)
                            Text(viewModel.newPassword)
                                .font(.title3)
                                .bold()
                        }
                        .padding()
                        .italic()
                    }
                }
                
            }
        }
        struct UsernameChangesView : View {
            
            struct NoUsernameChangesView : View { //maybe i want to elaborate this. maybe i dont. maybe its good enough
                var body : some View{
                    Text("No Username Changes")
                        .bold()
                }
            }
            
            @StateObject var viewModel : SettingsViewModel
            var body : some View {
                VStack{
                    Text("Username Changes")
                        .font(.headline)
                        .bold()
                    if(viewModel.newUsername == ""){
                        //no username changes
                        NoUsernameChangesView()
                        
                    }
                    else{
                        //we need to display the change that the username needs to be updated
                        VStack{
                            HStack{
                                Text("Old Username")
                                    .font(.callout)
                                Spacer()
                                Text("New Username")
                                    .font(.callout)
                                
                            }
                            HStack{
                                //because we have a filled "new username" we should display the old and new usernames for the user to see made changes and approve of them
                                Text(viewModel.golferUsername)
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Text(viewModel.newUsername)
                                    .font(.title3)
                                    .bold()
                            }
                            
                        }
                        .padding()
                        .italic()
                    
                        
                    }
                }
            }
        }
    }
}

#Preview {
    
    ApplyChangesView(navigationPath: .constant(NavigationPath()), viewModel: SettingsViewModel())
        .environmentObject(UserAuth().log_in_user(userID: 1))
    
}
