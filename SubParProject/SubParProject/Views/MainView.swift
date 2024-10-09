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
        VStack{
            Text("Main View")
            Spacer()
            Button {
                navigationManager.navigate(to: .home)
            } label: {
                Text("Sign_Out")
            }

        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
        
    }
}
