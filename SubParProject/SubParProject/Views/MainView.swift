//
//  MainView.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        ZStack{
            Main_View_Gradient()
            VStack{
                Text("SubPar")
                    .font(.title)
                    .fontWeight(.bold)
                HStack{
                    Button {
                        print("Button clicked... CURRENT LOGGED IN USER_ID: \(userAuth.get_userID() ?? -1)")
                    } label: {
                        Image("golf_ball_icon")
                            .resizable()  // Makes the image resizable
                            .scaledToFill() // Fills the frame completely
                            .frame(width: 100, height: 100) // Equal width and height for a square
                            .clipShape(Rectangle()) // Ensures the shape remains a square
                            .cornerRadius(10) // Optional: adds rounded corners
                    }
                    Spacer()
                    Button {
                        print("SEARCH FOR COURSES")
                    } label: {
                        Text("🔍")
                            .font(.system(size: 85))
                        
                    }
                    
                    
                }
                Spacer()
                Text("RECENTLY PLAYED COURSES")
                    .fontWeight(.bold)
                // Scrollable Content... need to replace at a later date with num couses visited by user
                               ScrollView {
                                   let num = 20
                                   VStack(spacing: 20) {
                                       ForEach(1...num, id: \.self) { index in
                                           Text("Dummy Content Item \(index)")
                                               .frame(maxWidth: .infinity)
                                               .padding()
                                               .background(Color.white)
                                               .cornerRadius(10)
                                               .shadow(radius: 5)
                                               .padding(.horizontal)
                                       }
                                   }
                               }
                               .padding(.vertical)
                Spacer()
                HStack(spacing: 40){
                    Button {
                        print("Stroke Counter")
                    } label: {
                        Text("Stroke Counter")
                    }
                    Button {
                        print("Stroke History")
                    } label: {
                        Text("Stroke History")
                    }
                    Button {
                        print("Upload Scorecard")
                    } label: {
                        Text("Upload Scorecard")
                    }
                    Button {
                        print("Social")
                    } label: {
                        Text("Social")
                    }

                }
                Spacer()
                Button {
                    navigationManager.navigate(to: .home)
                } label: {
                    Text("Sign_Out")
                }
                
            }
        }
        
        
    }
}

struct Main_View_Gradient: View{
    var body : some View{
        LinearGradient(gradient: Gradient(colors:
                                            [Color(red: 115/255, green: 185/255, blue:115/255),
                                             Color(red: 115/255, green: 175/255, blue:100/255),
                                             Color(red: 115/255, green: 200/255, blue:200/255),
                                             Color(red: 0/255, green: 200/255, blue:255/255),
                                             Color(red:255/255, green:255/255, blue:165/255)]),
                       startPoint: .bottom,
                       endPoint: .topTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
    }
}
