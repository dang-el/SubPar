//
//  ScorecardsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/27/25.
//

import SwiftUI

struct ScorecardsView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth : UserAuth
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue:115/255),
                                                 Color(red: 115/255, green: 175/255, blue:100/255),
                                                 Color(red: 115/255, green: 200/255, blue:200/255),
                                                 Color(red: 0/255, green: 200/255, blue:255/255),
                                                 Color(red:255/255, green:255/255, blue:165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Scorecards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button("Go Back") {
                    navigationPath.removeLast()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
        }
        
    }
}

struct ScorecardsView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardsView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
