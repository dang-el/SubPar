//
//  RecordStrokeViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/12/25.
//

import Foundation

final class RecordStrokeViewModel : ObservableObject {
    struct RecordStrokeResponse: Codable{
        let message: String
    }
    @Published var selectedOption : Int = 0
    @Published var distance : String = ""
    @Published var rating: String = ""
    let clubOptions = ["unassigned", "Three Iron", "Four Iron", "Five Iron", "Six Iron", "Seven Iron", "Eight Iron", "Nine Iron", "Wedge", "Three Wood", "Five Wood", "Driver"]
                   //wedges and other clubs later
    
    
    
    func printData(){
        print("clubType: \(self.getSelectedClub()), distance: \(self.distance), rating: \(self.rating)")
    }
    func recordStroke(userAuth: UserAuth) async throws {
        
        print("recording stroke in database for user: \(userAuth.get_userID() ?? -1)...")
        let jsonBody: [String: Any] = [
            "userID" : userAuth.get_userID() ?? -1, //provide -1 as default in case of null user id
            "clubType": self.getSelectedClub(),
            "distance": self.distance,
            "rating": self.rating
            ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error with json data")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
        }
        guard let url = URL(string: "http://127.0.0.1:6000/record-stroke") else {
            print("Error getting url")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("Error wioth response")
            let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        //when we get here we have a good status code response, meaning the stroke was added to the datatabse
        
        // Decode the JSON response
            let decoder = JSONDecoder()
            let recordStrokeResponse = try decoder.decode(RecordStrokeResponse.self, from: data)
        
        
        print("stroke added: \(recordStrokeResponse)")
        
    }
    func getClubOptions() -> [String] {
        return clubOptions
    }
    private func getSelectedClub() -> String {
        return self.clubOptions[self.selectedOption]
    }
    
}
