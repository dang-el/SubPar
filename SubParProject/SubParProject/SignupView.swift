//
//  SignupView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct SignupView: View {
    var body: some View {
            
        ZStack{
            //114 238 114
            Color.init(red: 114/255, green: 238/255, blue: 125/255)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Sign-Up")
                    .font(.largeTitle)
                    
                    .fontWeight(.heavy)
            
                    .padding(.top, 30)
                    
                //push content blow the title
                Spacer()
                //need input fields for the user to be able to enter a username, password, email, and or phone number. as well as a sign up button and a back button
                
            }
            
            
            
        }
        
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
