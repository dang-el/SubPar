//
//  StrokeHistoryViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/17/25.
//

import Foundation
final class StrokeHistoryViewModel : ObservableObject{
    struct Stroke: Codable, Identifiable {
        var id: Int
        var userID: Int
        var clubType: String
        var distance: Int
        var rating: Float

        // Mapping JSON keys to model properties if necessary
        enum CodingKeys: String, CodingKey {
            case id = "Stroke_ID"
            case userID = "Golfer_ID"
            case clubType = "ClubType"
            case distance = "Distance"
            case rating = "Rating"
        }
    }

    @Published var strokes: [Stroke] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchStrokes(for userID: Int) async {
        guard let url = URL(string: "http://127.0.0.1:6000/stroke-history") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }

        isLoading = true
        defer { isLoading = false }
        
        // Prepare JSON body with the userID
        let requestBody: [String: Any] = ["userID": userID]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to serialize JSON"
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
            }

            // Decode the JSON data
            let strokes = try JSONDecoder().decode([Stroke].self, from: data)

            // Update the strokes on the main thread
            DispatchQueue.main.async {
                self.strokes = strokes
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
        
    

}
