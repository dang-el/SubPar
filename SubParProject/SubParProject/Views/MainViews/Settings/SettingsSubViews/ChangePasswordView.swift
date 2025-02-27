//
//  ChangePasswordView.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/24/25.
//

import SwiftUI

struct ChangePasswordView : View{
    @Binding var navigationPath : NavigationPath
    @StateObject var viewModel : SettingsViewModel
    @State var newPassword = ""
    @State var confirmedPassword = ""
    @State var confirmed = false
    @State var confirmText = ""
    @State var message = ""
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
                Text("Change Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                if(message == ""){
                    EmptyView()
                }
                else{
                    Text(message)
                        .padding(.top, 10)
                }

                VStack(spacing: 90){
                    Spacer()
                    VStack(spacing: 75){
                        HStack{
                            Text("New Password")
                                .padding(.leading, 10)
                                .bold()
                            Spacer()
                            TextField(text: $newPassword) {
                                Text("Enter your New Password here")
                            }
                            .textInputAutocapitalization(.never)
                            .frame(width: 250)
                        }
                        HStack{
                            Text("Confirm Password")
                                .padding(.leading, 10)
                                .bold()
                            Spacer()
                            TextField(text: $confirmedPassword) {
                                Text("Confirm your Password here")
                            }
                            .frame(width: 250)
                            .textInputAutocapitalization(.never)
                        }
                        HStack{
                            Text("Type 'CONFIRM'")
                                .padding(.leading, 10)
                                .bold()
                            Spacer()
                            TextField(text: $confirmText) {
                                Text("Type 'CONFIRM' Here")
                            }
                            .frame(width: 250)
                        }
                    }
                    StyledButton(title: "Submit new Password Request") {
                        print("newPassword: '\(newPassword)'")
                        print("confirmedPassword: '\(confirmedPassword)'")
                        print("confirmText: '\(confirmText)'")
                        
                        if newPassword == confirmedPassword && confirmText == "CONFIRM" {
                            viewModel.newPassword = confirmedPassword
                            self.message = "Password Sucessfully Updated"
                        } else {
                            self.message = "Password could not be Updated"
                        }
                    }
                    .frame(width: 255)
                    .padding(.bottom, 50)
                    
                    
                    StyledButton(title: "Go Back", isPrimary: true) {
                        navigationPath.removeLast()
                    }
                    .frame(width: 255)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ChangePasswordView(navigationPath: .constant(NavigationPath()), viewModel: SettingsViewModel())
}
