//
//  SignupView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct SignupView: View {
    //state variables to update view on change
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                //114 238 114
                LinearGradient(gradient: Gradient(colors: [Color(red: 114/255, green: 238/255, blue: 125/255), Color.blue]),
                                               startPoint: .bottomLeading,
                                               endPoint: .topTrailing)
                                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text("Golfer Registration")
                        .font(.largeTitle)
                        
                        .fontWeight(.heavy)
                
                        .padding(.top, 75)
                    Spacer()
                    VStack(spacing:25){
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 400)
                            .foregroundColor(Color.black)
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 400)
                            .foregroundColor(Color.black)
                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 400)
                            .foregroundColor(Color.black)
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .frame(width: 400)
                            .foregroundColor(Color.black)
                            
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    Spacer()
                    HStack{
                        
                        NavigationLink(destination: HomeView()) {
                            Text("Cancel")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.black) // Button text color
                                
                        }
                        .padding(.trailing, 75.0)
                        NavigationLink(destination: EmptyView()) {
                            Text("Register")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.black) // Button text color
                                
                        }
                        .padding(.leading, 75.0)
                               
                    }
                    .padding(.bottom, 30)
                    
                }
                   
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
        
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
