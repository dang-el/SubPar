//
//  LoginViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/9/24.
//

import Foundation

final class LoginViewModel : ObservableObject {
    struct Login_Response : Codable{
        let message: String
        let golfer_id: Int
    }
    @Published var username: String = ""
    @Published var password: String = ""
    
    func sign_in() async throws -> Int{
        print("logging in user: \(self.username) \(self.password)")
        return try await sendSignupPostRequest()
    }
    func sendSignupPostRequest() async throws -> Int{
        print("sending sign in post request")
        
        guard let url = URL(string: "http://127.0.0.1:6000/sign-in") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let jsonBody: [String: Any] = [
            "username": self.username,
            "password": self.password,
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        // Decode the JSON response
            let decoder = JSONDecoder()
            let loginResponse = try decoder.decode(Login_Response.self, from: data)
            
            // Return the extracted ID
            return loginResponse.golfer_id
    }
}
