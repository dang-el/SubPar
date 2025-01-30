//
//  MainView.swift
//  SubParProject
//
//  Created by Owen Dangel on 10/8/24.
//
import SwiftUI

struct MainView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userAuth: UserAuth
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Main_View_Gradient()
                VStack {
                    Text("SubPar")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Button {
                            print("Button clicked... CURRENT LOGGED IN USER_ID: \(userAuth.get_userID() ?? -1)")
                        } label: {
                            Image("golf_ball_icon")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Rectangle())
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button {
                            print("SEARCH FOR COURSES")
                        } label: {
                            Text("🔍")
                                .font(.system(size: 85))
                        }
                    }

                    Spacer()

                    Text("RECENTLY PLAYED COURSES")
                        .fontWeight(.bold)
                    
                    ScrollView {
                        let num = 20
                        VStack(spacing: 20) {
                            ForEach(1...num, id: \..self) { index in
                                Text("Dummy Content Item \(index)")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)

                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 40) {
                            StyledButton(title: "Stroke Counter"){
                                navigationPath.append("StrokeCounterView")
                            }
                            StyledButton(title: "Stroke History"){
                                navigationPath.append("StrokeHistoryView")
                            }
                            StyledButton(title: "Upload Scorecard"){
                                navigationPath.append("UploadScorecardView")
                            }
                            StyledButton(title: "Social"){
                                navigationPath.append("SocialView")
                            }
                            StyledButton(title: "Scorecards"){
                                navigationPath.append("ScorecardsView")
                            }
                            
                        }
                        .padding(.horizontal) // Adds padding on the left and right
                    }
                    Spacer()
                    StyledButton(title: "Sign Out", isPrimary: true){
                        navigationManager.navigate(to: .home)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 75)
                    .padding(.trailing, 75)
                    
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "StrokeCounterView":
                    StrokeCounterView(navigationPath: $navigationPath)
                        .environmentObject(userAuth)
                case "StrokeHistoryView":
                    StrokeHistoryView(navigationPath: $navigationPath)
                        .environmentObject(userAuth)
                case "UploadScorecardView":
                    UploadScorecardView(navigationPath: $navigationPath)
                        .environmentObject(userAuth)
                case "SocialView":
                    SocialView(navigationPath: $navigationPath)
                        .environmentObject(userAuth)
                case "ScorecardsView" : ScorecardsView(navigationPath: $navigationPath, userAuth: userAuth)
                        .environmentObject(userAuth)
                    
                default:
                    Text("Unknown Destination")
                }
            }
        }
    }
}

struct Main_View_Gradient: View{
    var body : some View{
        LinearGradient(gradient: Gradient(colors:
                                            [Color(red: 115/255, green: 185/255, blue:115/255),
                                             Color(red: 115/255, green: 175/255, blue:100/255),
                                             Color(red: 115/255, green: 200/255, blue:200/255),
                                             Color(red: 0/255, green: 200/255, blue:255/255),
                                             Color(red:255/255, green:255/255, blue:165/255)]),
                       startPoint: .bottom,
                       endPoint: .topTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        
    }
}
