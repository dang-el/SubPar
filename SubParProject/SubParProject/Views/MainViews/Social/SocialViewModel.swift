//
//  SocialViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/20/25.
//

import Foundation
@MainActor
final class SocialViewModel : ObservableObject, Sendable{
    @Published var Friends: [GolferResponse] = [] // List of golfers fetched from the server
    @Published var loading: Bool = false
    struct GolferResponse: Codable, Hashable {
        var Golfer_ID : Int
        var Username: String
    }
    func getFriends(userAuth: UserAuth) async throws {
        loading = true // Start loading
        print("Fetching friend requests for user: \(userAuth.get_userID() ?? -1)...")
        let jsonBody: [String: Any] = ["userID" : userAuth.get_userID() ?? -1]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error with JSON data")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
        }
        guard let url = URL(string: "http://127.0.0.1:6000/search/friends") else {
            print("Error getting URL")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Error with response")
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
            // Decode the JSON response
            let decoder = JSONDecoder()
            let golfers = try decoder.decode([GolferResponse].self, from: data)

            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.Friends = golfers
                self.loading = false // Stop loading once the data is fetched
            }
            print("Fetched golfers: \(golfers)")

        } catch {
            DispatchQueue.main.async {
                self.loading = false // Stop loading in case of an error
            }
            print("Error fetching data: \(error.localizedDescription)")
            throw error
        }
    }
}
