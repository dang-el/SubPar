//
//  ContentView.swift
//  SubPar
//
//  Created by Owen Dangel on 9/6/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            // Set the background color to green and ignore safe area
        //TODO: make the colors more "green-like"
            //maybe we could apply something above the background to make it look like grass or a hole maybe
            
//            Color.init(red: 130/255, green: 1, blue: 85/255)
            
            
            Image("home_screen").resizable()
                .scaledToFill()
                .frame(minWidth: 0) // 👈 This will keep other views (like a large text) in the frame
                            .edgesIgnoringSafeArea(.all)
            
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                VStack{
                    
                    Text("SubPar")
                        .fontWeight(.heavy)
                        .bold(true)
                        .font(.largeTitle)
                        .offset(x: 0, y: -300)
                }
                HStack(spacing: 130){
                    Button("New User", action: {
                        
                    })
                    .foregroundColor(Color.black)
                    
                    Button("Returning User", action: {
                        
                    })
                    .foregroundColor(Color.black)
                    
                    
                }.offset(x:0, y:280)
                
                
            }
            
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
