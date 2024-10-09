//
//  ContentView.swift
//  SubPar
//
//  Created by Owen Dangel on 9/6/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        ZStack {
            
            Image("home_screen").resizable()
                .scaledToFill()
                .frame(minWidth: 0)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("SubPar")
                    .fontWeight(.heavy)
                    .bold(true)
                    .font(.largeTitle)
                    .padding(.top, 75)
                
                Spacer()
                
                Home_ButtonPanelView()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
    }
}
struct Home_ButtonPanelView: View{
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    var body: some View{
        HStack(spacing: 50){
            Button {
                navigationManager.navigate(to: .signup)
            } label: {
                Text("Register")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black) // Button text color
            }
            Button {
                navigationManager.navigate(to: .login)
            } label: {
                Text("Returning User")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black) // Button text color
            }

            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
            
    }
}
