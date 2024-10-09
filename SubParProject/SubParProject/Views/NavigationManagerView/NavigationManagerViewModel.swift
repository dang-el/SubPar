//
//  NavigationManagerViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//

import Foundation
//this class will update the current view and anything the navigation manager will update the view
final class NavigationManager : ObservableObject {
    
    @Published var currentView: ViewType = .home
    
    enum ViewType{
        case home
        case login
        case signup
        case main
    }
    
    func navigate(to view: ViewType){
        print("Navigating to: \(view)")
        currentView = view
    }
}
