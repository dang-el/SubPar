//
//  SignupViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//

import Foundation
final class SignupViewModel: ObservableObject{
    
    
    //@Published will cause the view to update since the var is being observed for changes
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
}
