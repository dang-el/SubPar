//
//  LoginView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
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
                    //need username and password fields and a button
                    NavigationLink(destination: HomeView()) {
                        Text("Cancel")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
