//
//  SignupView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
        RegistrationView()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
        
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

struct InputPanelView: View{
    //state variables to update view on change
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    var body: some View{
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
    }
}

struct ButtonPanelView: View{
    var body: some View{
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
    var body: some View{
        NavigationView {
            ZStack{
                BackgroundGradientView()
                VStack{
                    Text("Golfer Registration")
                        .font(.largeTitle)
                        
                        .fontWeight(.heavy)
                
                        .padding(.top, 75)
                    Spacer()
                    InputPanelView()
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    Spacer()
                    ButtonPanelView()
                    .padding(.bottom, 30)
                    
                }
                   
            }
        }
    }
}
