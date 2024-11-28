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
    
    func registerNewAccount(){
        print("Registering account for User: \(self.username) \(self.password) \(self.email) \(self.phoneNumber)")
        let response = sendRegisterPostRequest()
        return response
    }
    
    func sendRegisterPostRequest(){
        guard let url = URL(string: "http://127.0.0.1:6000/register") else {
            print("server down or invalid url")
            return
        }
        // make json body data - take from @published vars
        
        let jsonBody: [String: Any] = [
            "username" : username,
            "password" : password,
            "email" : email,
            "phone_number": phoneNumber
        ]
        //serialize
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error serializing json data")
            return
        }
        //create the actual request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        //the http request has been filled out correctly with the data that is needed to be in it
        // 5. Send the request using URLSession
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Handle response
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                // Parse response data if any
                if let data = data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                    
                }
                
            }
            
            // 6. Start the network task
            task.resume()
    }
}
