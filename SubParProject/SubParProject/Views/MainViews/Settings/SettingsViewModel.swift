//
//  SettingsViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/10/25.
//

import Foundation
@MainActor
final class SettingsViewModel : ObservableObject, Sendable {
    @Published var golferUsername = ""
    @Published var golferPhoneNumber = ""
    @Published var golferEmail = ""
    @Published var newPhoneNumber = ""
    @Published var newEmail = ""
    @Published var newPassword = ""
    @Published var newUsername = ""
    @Published var isAdministrator = false // will update after the view is first rendered and an api call is made
    @Published var isEstablishmemnt = false // will update after the view is first rendered and an api call is made
    @Published var wasFetched = false
    @Published var applyChangesResponse = ""
    enum SettingsDestination: Hashable {
        case changePassword
        case applyChanges
        case adminView
        case establishmentView
    }
    struct UserResponse : Codable {
        var user : SignedInUser
        var isAdministrator : Bool
        var isEstablishment : Bool
    }
    struct SignedInUser : Codable{
        var Username : String
        var Email : String
        var Phone_Number : String
    }
    func getUserInformation(userAuth: UserAuth) async {
        print("getUserInformation() CALLED")

        do {
            let jsonBody: [String: Any] = ["UserID": userAuth.get_userID() ?? -1]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
                print("❌ Error serializing JSON")
                return
            }

            guard let url = URL(string: "http://127.0.0.1:6000/golfer/info") else {
                print("❌ Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)
            print("✅ Received response:", response)

            // Decode the JSON data
            let userResp = try JSONDecoder().decode(UserResponse.self, from: data)
            // Update UI on main thread
            let user = userResp.user
            DispatchQueue.main.async {
                self.golferUsername = user.Username
                if(user.Email != ""){
                    self.golferEmail = user.Email
                }
                else{
                    self.golferEmail = "No Email to Retrieve"
                }
                
                if(user.Phone_Number != ""){
                    self.golferPhoneNumber = user.Phone_Number
                }
                else{
                    self.golferPhoneNumber = "No Phone Number to Retrieve"
                }
                self.isAdministrator = userResp.isAdministrator
                self.isEstablishmemnt = userResp.isEstablishment
                self.wasFetched = true
            }

        } catch {
            print("❌ Error in getUserInformation():", error)
        }
    }
    func applyChanges(userAuth : UserAuth){
        print("new username \(self.newUsername) new email \(self.newEmail) new phone number \(self.newPhoneNumber)")
        //need to send this data to the server to attempt to change the current users data. need to return message to set to applyChangesResponse
    }

}
