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
                
                LinearGradient(gradient: Gradient(colors: [Color(red: 114/255, green: 238/255, blue: 125/255), Color.blue]),
                                               startPoint: .bottomLeading,
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
