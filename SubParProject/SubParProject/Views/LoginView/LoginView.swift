//
//  LoginView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors:
            [Color(red: 115/255, green: 185/255, blue:115/255),
            Color(red: 115/255, green: 175/255, blue:100/255),
            Color(red: 115/255, green: 200/255, blue:200/255) ,
            Color(red: 0/255, green: 200/255, blue:255/255),
            Color(red:255/255, green:255/255, blue:165/255)]),
            startPoint: .bottom,
            endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Log-in")
                    .font(.largeTitle)
                
                    .fontWeight(.heavy)
                
                    .padding(.top, 30)
                
                //push content blow the title
                Spacer()
                Login_InputPanelView()
                Spacer()
                //need username and password fields and a button
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
                    Spacer()
                    Button {
                        navigationManager.navigate(to: .main)
                    } label: {
                        Text("Log-In")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.black) // Button text color
                    }
                }
                

                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    
    }
}
struct Login_InputPanelView : View{
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some View{
        VStack(spacing: 75){
            TextField("Username", text: $loginViewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $loginViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .frame(width: 400)
                .foregroundColor(Color.black)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)

        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
