//
//  SignupView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        RegistrationView()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
    
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        //if you want to use the buttons you have to pass in a Navigaton Manager instead of SignupView.
        SignupView()
    }
}

struct Signup_InputPanelView: View{
    //state variables to update view on change
    @ObservedObject var viewModel : SignupViewModel
    var body: some View{
        
        VStack(spacing:25){
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            TextField("Phone Number", text: $viewModel.phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .keyboardType(.numberPad)
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
        }
    }
}

struct Signup_ButtonPanelView: View{
    @ObservedObject var viewModel : SignupViewModel
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    var body: some View{
        HStack{
            Button {
                navigationManager.navigate(to: .home)
            } label: {
                Text("Cancel")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black) // Button text color
            }
            .padding(.trailing, 75.0)
            Button {
                Task {
                    do {
                        let userID = try await viewModel.registerNewAccount()
                        print("Registration successful, Golfer_ID: \(userID)")
                        navigationManager.navigate(to: .main)
                    } catch {
                        print("Error registering account: \(error.localizedDescription)")
                    }
                }
            } label: {
                
                Text("Register")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black) // Button text color
                
                
            }
            .padding(.leading, 75.0)
        }
    }
}
struct BackgroundGradientView: View{
    var body: some View{
        //114 238 114
        LinearGradient(gradient: Gradient(colors:
                                            [Color(red: 115/255, green: 185/255, blue:115/255),
                                             Color(red: 115/255, green: 175/255, blue:100/255),
                                             Color(red: 115/255, green: 200/255, blue:200/255) ,
                                             Color(red: 0/255, green: 200/255, blue:255/255),
                                             Color(red:255/255, green:255/255, blue:165/255)]),
                       startPoint: .bottom,
                       endPoint: .topTrailing)
        .edgesIgnoringSafeArea(.all)
        
    }
}
struct RegistrationView: View{
    @StateObject var viewModel = SignupViewModel()
    var body: some View{
        
        ZStack{
            BackgroundGradientView()
            VStack{
                Text("Golfer Registration")
                    .font(.largeTitle)
                
                    .fontWeight(.heavy)
                
                    .padding(.top, 75)
                Spacer()
                Signup_InputPanelView(viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                Spacer()
                Signup_ButtonPanelView(viewModel: viewModel)
                    .padding(.bottom, 30)
                
            }
            
        }
        
    }
}

