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
            Color.init(red: 100/255, green: 1, blue: 100/255)
            
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                VStack{
                    
                    Text("SubPar")
                        .bold(true)
                        .font(.system(size: 48))
                    Image("red_shirt_golfer").resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                    Text("Welcome!")
                        .font(.system(size: 24))
                    
                }
                HStack{
                    Button("New User", action: {
                        
                    })
                    .padding()
                    Button("Returning User", action: {
                        
                    })
                }
            }
            
            
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
