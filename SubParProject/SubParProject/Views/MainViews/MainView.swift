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

                    HStack(spacing: 40) {
                        Button {
                            navigationPath.append("StrokeCounterView")
                        } label: {
                            Text("Stroke Counter")
                        }
                        Button {
                            navigationPath.append("StrokeHistoryView")
                        } label: {
                            Text("Stroke History")
                        }
                        Button {
                            navigationPath.append("UploadScorecardView")
                        } label: {
                            Text("Upload Scorecard")
                        }
                        Button {
                            navigationPath.append("SocialView")
                        } label: {
                            Text("Social")
                        }
                    }

                    Spacer()

                    Button {
                        navigationManager.navigate(to: .home)
                    } label: {
                        Text("Sign_Out")
                    }
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "StrokeCounterView":
                    StrokeCounterView(navigationPath: $navigationPath)
                case "StrokeHistoryView":
                    StrokeHistoryView(navigationPath: $navigationPath)
                case "UploadScorecardView":
                    UploadScorecardView(navigationPath: $navigationPath)
                case "SocialView":
                    SocialView(navigationPath: $navigationPath)
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
