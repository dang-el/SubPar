//
//  ScorecardsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/27/25.
//

import SwiftUI

struct ScorecardsView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userAuth : UserAuth
    @ObservedObject var viewModel : ScorecardsViewModel
    // Initialize ScorecardsView with UserAuth
    // Initialize ScorecardsView with UserAuth
        init(navigationPath: Binding<NavigationPath>, userAuth: UserAuth) {
            _viewModel = ObservedObject(wrappedValue: ScorecardsViewModel(userAuth: userAuth))
            _navigationPath = navigationPath
        }
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue:115/255),
                                                 Color(red: 115/255, green: 175/255, blue:100/255),
                                                 Color(red: 115/255, green: 200/255, blue:200/255),
                                                 Color(red: 0/255, green: 200/255, blue:255/255),
                                                 Color(red:255/255, green:255/255, blue:165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Scorecards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                ScorecardViewer(viewModel: viewModel)
                    .onAppear(){
                        Task{
                            try await viewModel.fetchCards()
                        }
                    }
                
                Spacer()
                Button("Go Back") {
                    navigationPath.removeLast()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
struct ScorecardViewer: View {
    @ObservedObject var viewModel: ScorecardsViewModel

    var body: some View {
        ScrollView {
                    VStack(alignment: .center) {
                        if viewModel.isLoading {
                            ProgressView("Loading Scorecards...")
                                .padding()
                        } else if viewModel.ScorecardImages.isEmpty {
                            Text("No scorecards available")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.ScorecardImages.reversed(), id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                }
    }
}

struct ScorecardsView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardsView(navigationPath: .constant(NavigationPath()), userAuth: UserAuth().log_in_user(userID: 1))
            .environmentObject(UserAuth().log_in_user(userID: 1))
    }
}
