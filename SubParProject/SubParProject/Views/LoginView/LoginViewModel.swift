//
//  LoginViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/9/24.
//

import Foundation

final class LoginViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
}
