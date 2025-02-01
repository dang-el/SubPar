//
//  UploadScorecardView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    
    @StateObject var viewModel: UploadScorecardViewModel
    @EnvironmentObject var userAuth : UserAuth
    var body: some View {
        VStack(spacing: 50) {
            // Display the selected image
            if let selectedImage = viewModel.selectedImage {
                VStack{
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                    Button {
                        Task{
                            try await viewModel.uploadImage(userAuth: userAuth)
                        }
                        
                    } label: {
                        Text("Upload")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                    }

                }
                
            } else {
                Text("No photo selected")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
            }

            // Photos Picker Button
            PhotosPicker(
                selection: $viewModel.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select Photo")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .onChange(of: viewModel.selectedItem) { newItem in
                guard let newItem = newItem else { return }
                
                Task {
                    do {
                        if let data = try await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            // Ensure UI updates happen on the main thread
                            await MainActor.run {
                                viewModel.selectedImage = uiImage
                            }
                        } else {
                            print("Failed to load image data")
                        }
                    } catch {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            }

        }
        .padding()
    }
}

struct UploadScorecardView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth : UserAuth
    @StateObject var viewModel : UploadScorecardViewModel = UploadScorecardViewModel()
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue:115/255),
                                                 Color(red: 115/255, green: 175/255, blue:100/255),
                                                 Color(red: 115/255, green: 200/255, blue:200/255) ,
                                                 Color(red: 0/255, green: 200/255, blue:255/255),
                                                 Color(red:255/255, green:255/255, blue:165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Upload Scorecard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                PhotoPickerView(viewModel: viewModel)
                    .environmentObject(userAuth)
                Spacer()
                Button("Go Back") {
                    navigationPath.removeLast()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

struct UploadScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        UploadScorecardView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
