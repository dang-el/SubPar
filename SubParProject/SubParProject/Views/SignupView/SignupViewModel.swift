//
//  SignupViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//
import Foundation

final class SignupViewModel: ObservableObject {
    
    struct RegistrationResponse: Codable {
            let message: String
            let golfer_id: Int
        }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    
    func registerNewAccount() async throws -> Int {
        print("Registering account for User: \(self.username) \(self.password) \(self.email) \(self.phoneNumber)")
        return try await sendRegisterPostRequest()
    }
    
    func sendRegisterPostRequest() async throws -> Int {
        guard let url = URL(string: "http://127.0.0.1:6000/register") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let jsonBody: [String: Any] = [
            "username": username,
            "password": password,
            "email": email,
            "phone_number": phoneNumber
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
            let registrationResponse = try decoder.decode(RegistrationResponse.self, from: data)
            
            // Return the extracted ID
            return registrationResponse.golfer_id
    }
}
