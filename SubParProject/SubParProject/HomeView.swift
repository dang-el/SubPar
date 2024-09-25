//
//  ContentView.swift
//  SubPar
//
//  Created by Owen Dangel on 9/6/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: String? = nil
    var body: some View {
        
        NavigationView {
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
                            .padding(.top, 75)
                    }
                    Spacer()
                    
                    HStack(spacing: 50){
                        NavigationLink(destination: SignupView()) {
                            Text("Register")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.black) // Button text color
                                
                        }

                        
                        NavigationLink(destination: LoginView()) {
                            Text("Returning User")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.black) // Button text color
                                
                        }

                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    
                }
                
                
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
