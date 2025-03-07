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
    @StateObject var viewModel : MainViewModel = MainViewModel()

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
                            navigationPath.append("SettingsView")
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

                    Text("COURSES")
                        .fontWeight(.bold)
                    
                    CoursesView(viewModel : viewModel)
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
                case "SettingsView" :
                    SettingsView(navigationPath: $navigationPath)
                        .environmentObject(userAuth)
                default:
                    Text("Unknown Destination")
                }
            }
        }
    }
    struct CoursesView: View {
        @StateObject var viewModel: MainViewModel

        var body: some View {
            ScrollView {
                // Show a loading message until courses are fetched
                if(viewModel.isLoading){
                    HStack{
                        Text("Loading Courses...")
                        ProgressView()
                    }
                    .foregroundStyle(.quaternary)
                }
                else if viewModel.courses.isEmpty {
                    Text("Loading Courses...")
                        .padding()
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.courses, id: \.Name) { course in
                            VStack(alignment: .leading) {
                                Text(course.Name)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                                Text("Established: \(course.Established)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Difficulty: \(course.Difficulty)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.getCourses()
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
