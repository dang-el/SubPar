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
    @Published var messageFromServer : String = ""
    @Published var courses : [Course] = []
    @Published var isLoading : Bool = false
    struct CoursesResponse : Codable{
        var courses : [Course]
    }
    struct Course : Codable {
        var Course_ID : Int
        var Name : String
        var Established : String
        var Difficulty : String
    }
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
        var status: Int
        var message: String
    }
    enum EstablishmentsDestination : Hashable {
        case addCourse
    }
    enum AddCourseDestination : Hashable {
        case add9Holes
    }
    
    func uploadCourse(userAuth : UserAuth) async throws {
        
        let requestBody = UploadCourseRequest(userID: userAuth.get_userID() ?? -1, courseName: self.courseName, dateEstablished: self.dateEstablished, slopeRating: self.slopeRating, holes: self.holes)
        
        
        
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

            let (data, _) = try await URLSession.shared.data(for: request)
            

            // Decode the JSON data
            let estResp = try JSONDecoder().decode(EstablishmentsResponse.self, from: data)
            // Update UI on main thread
            DispatchQueue.main.async {
                self.messageFromServer = estResp.message
            }

        } catch {
            print("❌ Error in uploadCourse():", error)
        }
    }
    func getCoursesOfEstablishment(userAuth: UserAuth) async {
        self.isLoading = true
        

        guard let url = URL(string: "http://127.0.0.1:6000/courses/managed-by/\(userAuth.get_userID() ?? -1)") else {
            print("❌ Invalid URL")
            self.isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                
                let json = try JSONDecoder().decode(CoursesResponse.self, from: data)
                
                await MainActor.run {
                    self.courses = json.courses
                    
                    self.isLoading = false
                }
            } else {
                await MainActor.run { self.isLoading = false }
            }
        } catch {
            print("❌ Error fetching courses:", error)
            await MainActor.run { self.isLoading = false }
        }
        
    }

}
