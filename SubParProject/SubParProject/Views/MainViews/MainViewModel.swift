//
//  MainViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 3/6/25.
//

import Foundation
@MainActor
final class MainViewModel : ObservableObject, Sendable {
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
    func getCourses() async {
        self.isLoading = true
        // The URL for the GET request
        if let url = URL(string: "http://127.0.0.1:6000/courses") {
            
            
            // Create a data task to send the GET request
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                // Check for errors
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                // Check if the response is valid
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    
                    // Process the received data
                    if let data = data {
                        // Here, you can decode the data or handle it however you need
                        
                        
                        // If you expect JSON, you can decode it into a model
                        do {
                            let json = try JSONDecoder().decode(CoursesResponse.self, from: data)
                            
                            DispatchQueue.main.async {
                                self.courses = json.courses
                                self.isLoading = false
                            }
                        } catch {
                            print("Error parsing JSON: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Error: Invalid response or status code")
                }
            }
            
            // Start the task
            task.resume()
        }

    }
}
