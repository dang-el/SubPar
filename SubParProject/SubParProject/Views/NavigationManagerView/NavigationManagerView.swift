//
//  NavigationManagerView.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//

import SwiftUI

struct NavigationManagerView: View {
    @StateObject private var navigationManager = NavigationManager()
    @StateObject private var userAuth = UserAuth()
    //if the user is authenticted they need to be navigated to the main screen
    //call navigate with the main view to navigate
    var body: some View {
            NavigationStack {
                switch navigationManager.currentView {
                case .home:
                    HomeView()
                        .environmentObject(navigationManager)
                        .environmentObject(userAuth)
                case .login:
                    LoginView()
                        .environmentObject(navigationManager)
                        .environmentObject(userAuth)
                case .signup:
                    SignupView()
                        .environmentObject(navigationManager)
                        .environmentObject(userAuth)
                case .main:
                    MainView()
                        .environmentObject(navigationManager)
                        .environmentObject(userAuth)
                }
            }
        }
}

struct NavigationManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationManagerView()
    }
}
