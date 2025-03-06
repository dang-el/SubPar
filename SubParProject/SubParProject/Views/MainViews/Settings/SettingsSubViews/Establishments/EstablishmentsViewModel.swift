//
//  EstablishmentsViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/28/25.
//

import Foundation

@MainActor
final class EstablishmentsViewModel : ObservableObject {
    @Published var holes: [HoleData] = Array(repeating: HoleData(), count: 9)
    @Published var courseName = ""
    @Published var dateEstablished = ""
    @Published var slopeRating = ""
    @Published var Establishments : [EstablishmentsResponse] = []
    struct HoleData : Codable {
        var holeNumber : String = ""
        var par: String = ""
        var yardage: String = ""
        var description: String = """
Your Summary Here... (<- to save summary delete all text and write new.  -v  )

The par for this hole is 4, with a slight dogleg to the right.
Fairway bunkers on the left side require precision off the tee.
Approach shot needs to carry the front bunker to reach the green.
Beware of the slope on the right side of the green!
"""
    }
    struct UploadCourseRequest : Codable {
        var userID: Int
        var courseName : String
        var dateEstablished: String
        var slopeRating: String
        var holes: [HoleData]
    }
    struct EstablishmentsResponse : Codable {
        var name: String
    }
    enum EstablishmentsDestination : Hashable {
        case addCourse
    }
    enum AddCourseDestination : Hashable {
        case add9Holes
    }
    
    func uploadCourse(userAuth : UserAuth) async throws {
        print("uploading \(self.courseName), \(self.dateEstablished), \(self.slopeRating)...")
        let requestBody = UploadCourseRequest(userID: userAuth.get_userID() ?? -1, courseName: self.courseName, dateEstablished: self.dateEstablished, slopeRating: self.slopeRating, holes: self.holes)
        print(requestBody)
        
        
        do {
            //encode struct to jsonData
            guard let jsonData = try? JSONEncoder().encode(requestBody) else {
                print("❌ Error encoding JSON")
                return
            }

            guard let url = URL(string: "http://127.0.0.1:6000/establishments/course/upload") else {
                print("❌ Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.data(for: request)
            print("✅ Received response:", response)

            // Decode the JSON data
            //let estResp = try JSONDecoder().decode(EstablishmentsResponse.self, from: data)
            // Update UI on main thread
//            DispatchQueue.main.async {
//
//            }

        } catch {
            print("❌ Error in uploadCourse():", error)
        }
    }
}
