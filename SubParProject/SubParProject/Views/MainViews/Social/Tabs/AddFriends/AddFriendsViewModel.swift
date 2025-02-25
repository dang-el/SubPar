import Foundation
@MainActor
final class AddFriendsViewModel: ObservableObject, Sendable {
    struct GolferResponse: Codable, Hashable, Sendable {
        var Golfer_ID : Int
        var Username: String
    }

    @Published var Golfers: [GolferResponse] = [] // List of golfers fetched from the server
    @Published var friendsName: String = "" {
        didSet {
            friendsNameStringUpdated()
        }
    }

    // Function to handle the update of the friend's name and trigger the fetch.
    func friendsNameStringUpdated() {
        if friendsName.isEmpty {
            Golfers = [] // Clear golfers if search is empty
            return
        }
        
        Task {
            do {
                try await collectGolfersOfName(friendsName: friendsName)
            } catch {
                print("Error fetching golfers: \(error.localizedDescription)")
            }
        }
    }

    // Fetch golfers by the entered name
    private func collectGolfersOfName(friendsName: String) async throws {
        print("Collecting golfers starting with name: \(friendsName)")

        let jsonBody: [String: Any] = ["friendsName": friendsName]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error serializing JSON")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
        }

        guard let url = URL(string: "http://127.0.0.1:6000/search/golfers") else {
            print("Error creating URL")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        // Check the HTTP response status code
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            print("Server returned error: \(errorMessage)")
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }

        // Decode the JSON response
        let decoder = JSONDecoder()
        do {
            let golfers = try decoder.decode([GolferResponse].self, from: data)

            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.Golfers = golfers
            }

            print("Fetched golfers: \(golfers)")
        } catch {
            print("Error decoding response: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addFriend(golfer: GolferResponse, userAuth: UserAuth) {
        // Get the requesting user's ID (from userAuth)
        let requestingUserID = userAuth.get_userID() ?? -1
        
        // Get the receiving user's ID (from the golfer)
        let receivingUserID = golfer.Golfer_ID
        
        print("Sending friend request: User \(requestingUserID) -> Golfer \(receivingUserID)")

        // Create a JSON body to send to the server with both IDs
        let jsonBody: [String: Any] = [
            "requestingUserID": requestingUserID,
            "receivingUserID": receivingUserID
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error serializing JSON")
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:6000/addFriend") else {
            print("Error creating URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create a copy of the request object for use inside the async block
        let requestCopy = request
        
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(for: requestCopy)
                
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    print("Server returned error: \(errorMessage)")
                } else {
                    print("Friend request sent successfully!")
                }
            } catch {
                print("Error sending friend request: \(error.localizedDescription)")
            }
        }
    }

}
