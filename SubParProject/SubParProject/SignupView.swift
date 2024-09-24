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
            
        ZStack{
            //114 238 114
            Color.init(red: 114/255, green: 238/255, blue: 125/255)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Golfer Registration")
                    .font(.largeTitle)
                    
                    .fontWeight(.heavy)
            
                    .padding(.top, 75)
                Spacer()
                VStack(spacing:20){
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 425)
                        .foregroundColor(Color.black)
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 425)
                        .foregroundColor(Color.black)
                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 425)
                        .foregroundColor(Color.black)
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 425)
                        .foregroundColor(Color.black)
                        
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                Spacer()
                HStack{
                    
                    Button {
                        //code here for button press
                    } label: {
                        Text("Cancel")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            .padding(.trailing, 50.0)
                            
                    }
                    
                    Button {
                        //code here for button press
                    } label: {
                        Text("Register")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 100, height: 50)
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            
                            .padding(.leading, 50.0)
                        
                    }
                    
                    
                    
                }
                .padding()
                .padding(.bottom, 30)
                
                

                
                
            }
            
            
            
            
            
            
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
