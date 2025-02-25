//
//  ScorecardsViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/27/25.
//

import Foundation
import UIKit
@MainActor
final class ScorecardsViewModel : ObservableObject, Sendable{
    @Published var isLoading: Bool = false
    @Published var pageNum: Int = 0
    @Published var isMore: Bool = false
    @Published var ScorecardImages : [UIImage] = []
    private var Scorecards : [ScorecardsResponse] = []
    struct ScorecardsResponse : Codable, Hashable {
        var Scorecard_ID : Int
        var img : String
    }
    var userAuth: UserAuth?

        // Initialize with UserAuth
    // Initialize with UserAuth
        init(userAuth: UserAuth? = nil) {
            self.userAuth = userAuth
            Task {
                try? await fetchCards()
            }
        }
    
    
    func fetchCards() async throws {
        isLoading = true // Start loading
        print("Fetching scorecards for user: \(userAuth!.get_userID() ?? -1)...")
        let jsonBody: [String: Any] =   ["userID" : userAuth!.get_userID() ?? -1, "page_num" : pageNum]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            print("Error with JSON data")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
        }
        guard let url = URL(string: "http://127.0.0.1:6000/scorecards/retrieve") else {
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
            let scorecards = try decoder.decode([ScorecardsResponse].self, from: data)

            // Update the UI on the main thread
            DispatchQueue.main.async {
                            self.Scorecards = scorecards
                            self.scorecardsToScorecardImages() // Ensure images update after scorecards are set
                            self.isLoading = false
                        }
            print("Fetched Scorecards")

        } catch {
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading in case of an error
            }
            print("Error fetching data: \(error.localizedDescription)")
            throw error
        }
        self.isMore = isMoreScorecards()
    }
    
    
    func pageAdvance(inc: Int){
        pageNum += inc
        Task{
            try await fetchCards()
        }
    }
    
    
    
    private func decodeBase64ToImage(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String) {
            return UIImage(data: data)
        }
        return nil
    }
    private func scorecardsToScorecardImages(){
        print("Converting scorecards to images")
        self.ScorecardImages = self.Scorecards.compactMap { scorecard in
                return decodeBase64ToImage(base64String: scorecard.img)
            }
    }
    
    private func isMoreScorecards()->Bool{
        //take the current page number +1 and check the database to see if a single result is returned
        return false
    }
}
