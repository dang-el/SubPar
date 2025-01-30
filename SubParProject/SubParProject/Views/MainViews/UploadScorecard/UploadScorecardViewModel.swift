//
//  UploadScorecardViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/19/25.
//

import Foundation
import SwiftUI
import PhotosUI

class UploadScorecardViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?
        
    
    
    
    func uploadImage(userAuth: UserAuth) async throws {
        guard let image = selectedImage else { return }
        // Implement upload logic here
        print("Uploading image: \(image)")
        if let imageData = selectedImage!.jpegData(compressionQuality: 1.0) {
            // Save `imageData` to the database
            print("image converted to jpeg data \(imageData)")
//            imageData.forEach { byte in
//                        print(String(format: "%02X", byte), terminator: " ")
//                    }
            let base64EncodedString = imageData.base64EncodedString()
            print("Base64 Encoded String: \(base64EncodedString.count)")
            
            let json : [String: Any] = [
                "image_data" : base64EncodedString,
                "userID" : userAuth.get_userID() ?? -1
            ]
            guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
                print("Error with json data")
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
            }
            guard let url = URL(string: "http://127.0.0.1:6000/scorecards/upload") else {
                print("Error getting url")
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            // Check HTTP response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Error wioth response")
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            
        } else {
            print("Failed to convert UIImage to Data")
        }
    }
    
    
    
}
