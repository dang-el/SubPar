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
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil

    
    
    
    func uploadImage() {
        guard let image = selectedImage else { return }
        // Implement upload logic here
        print("Uploading image: \(image)")
    }
    
    
    
}
