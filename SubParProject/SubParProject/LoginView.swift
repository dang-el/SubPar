//
//  LoginView.swift
//  SubParProject
//
//  Created by Owen Dangel on 9/24/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack{
            
            Color.init(red: 114/255, green: 238/255, blue: 125/255)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Log-in")
                    .font(.largeTitle)
                
                    .fontWeight(.heavy)
                
                    .padding(.top, 30)
                
                //push content blow the title
                Spacer()
                //need username and password fields and a button
            }
        }
        
    
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
