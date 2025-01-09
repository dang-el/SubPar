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
                Text("Main View")
                HStack{
                    Button {
                        print("Button clicked")
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
