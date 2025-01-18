//
//  UserAuth.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//

import Foundation

final class UserAuth: ObservableObject{
    @Published var logged_in_user: Int? = nil
    func log_in_user(userID: Int) -> Self{
        logged_in_user = userID
        return self
    }
    func get_userID() -> Int? {
        return logged_in_user
    }
}

