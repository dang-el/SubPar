//
//  StrokeHistoryView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//
//
//  StrokeHistoryView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI

struct StrokeHistoryView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = StrokeHistoryViewModel() // Initialize ViewModel
    @EnvironmentObject var userAuth: UserAuth
    var body: some View {
        ZStack {
            Stroke_History_View_Gradient()

            VStack {
                // Header and Filters
                VStack(spacing: 20) {
                    Text("Stroke History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Filters_View()
                }

                Spacer() // Push content to the center

                // Stroke View
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Loading Stroke History...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Stroke_View(strokes: viewModel.strokes)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer() // Push the button to the bottom

                // Navigation Button
                Button("Go Back") {
                    navigationPath.removeLast()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            // Fetch stroke data on view load
            Task {
                await viewModel.fetchStrokes(for: userAuth.get_userID() ?? -1) // Pass userID or get it dynamically
            }
        }
    }
}

struct Filters_View: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Filters")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    StyledButton(title: "Club Type"){
                        
                    }
                    StyledButton(title: "Over Distance"){
                        
                    }
                    StyledButton(title: "Under Distance"){
                        
                    }
                }

                HStack(spacing: 20) {
                    StyledButton(title: "Over Rating"){
                        
                    }
                    StyledButton(title: "Under Rating"){
                        
                    }
                    StyledButton(title: "Clear Filters"){
                        
                    }
                }

                HStack {
                    Spacer()
                    StyledButton(title: "Search", isPrimary: true){
                        
                    }
                        .frame(maxWidth: 150)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct StyledButton: View {
    var title: String
    var isPrimary: Bool = false
    var action: () -> Void // Closure to execute on button tap
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 14)) // Adjust font size
                .fontWeight(.bold)
                .padding(.vertical, 10) // Adjust padding for better height
                .padding(.horizontal, 20) // Adjust padding for better width
                .frame(maxWidth: .infinity) // Allow button to expand to fill space
                .background(isPrimary ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isPrimary ? .white : .black)
                .cornerRadius(8)
                .shadow(radius: 3)
        }
    }
}

struct Stroke_View: View {
    let strokes: [StrokeHistoryViewModel.Stroke] // Accept strokes from the ViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(strokes.reversed()) { stroke in
                    VStack(alignment: .leading) {
                        Text("Club: \(stroke.clubType)")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Distance: \(stroke.distance) yards")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Rating: \(stroke.rating)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
            }
            .padding()
            .frame(maxWidth: 1000)
        }
        .padding(.bottom, 35)
    }
}

struct Stroke_History_View_Gradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors:
                                            [Color(red: 115/255, green: 185/255, blue: 115/255),
                                             Color(red: 115/255, green: 175/255, blue: 100/255),
                                             Color(red: 115/255, green: 200/255, blue: 200/255),
                                             Color(red: 0/255, green: 200/255, blue: 255/255),
                                             Color(red: 255/255, green: 255/255, blue: 165/255)]),
                       startPoint: .bottom,
                       endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct StrokeHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeHistoryView(navigationPath: .constant(NavigationPath()))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
