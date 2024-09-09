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
            // Set the background color to green and ignore safe area
        //TODO: make the colors more "green-like"
            //maybe we could apply something above the background to make it look like grass or a hole maybe
            
//            Color.init(red: 130/255, green: 1, blue: 85/255)
            
            
            Image("golf_ball_next_to_hole").resizable()
                .scaledToFill()
                .frame(minWidth: 0) // 👈 This will keep other views (like a large text) in the frame
                            .edgesIgnoringSafeArea(.all)
            
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                VStack{
                    
                    Text("SubPar")
                        .bold(true)
                        .font(.system(size: 48))
                        .offset(x: 0, y: -120)
                }
                HStack(spacing: 130){
                    Button("New User", action: {
                        
                    })
                    
                    
                    
                    Button("Returning User", action: {
                        
                    })
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
