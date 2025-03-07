//
//  EstablishmentsView.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/24/25.
//

import SwiftUI

struct EstablishmentsView: View {
    @State var isEstablishment: Bool
    @Binding var navigationPath : NavigationPath
    @ObservedObject var viewModel : EstablishmentsViewModel = EstablishmentsViewModel()
    @EnvironmentObject var userAuth : UserAuth
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
                Text("Establishments")
                    .font(.largeTitle)
                    .bold()
                VStack{
                    if(isEstablishment){
                        CoursesView(viewModel: viewModel)
                            .environmentObject(userAuth)
                            .onAppear {
                                Task {
                                    await viewModel.getCoursesOfEstablishment(userAuth: userAuth)
                                }
                            }
                        Spacer()
                        VStack(spacing: 45){
                            StyledButton(title: "Add a Course") {
                                print("navigate to add course view")
                                navigationPath.append(EstablishmentsViewModel.EstablishmentsDestination.addCourse)
                            }
                            .frame(width: 255)
                            StyledButton(title: "Go Back", isPrimary: true) {
                                navigationPath.removeLast()
                            }
                            .frame(width: 255)
                        }
                    }
                    else{
                        VStack{
                            Spacer()
                            NeedSignupView()
                            Spacer()
                            StyledButton(title: "Go Back", isPrimary: true) {
                                navigationPath.removeLast()
                            }
                            .frame(width: 255)
                        }
                        
                    }
                }
                .padding()
                
                
                
                
                
            }
        }
       
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: EstablishmentsViewModel.EstablishmentsDestination.self) { destination in
            switch destination {
            case .addCourse:
                AddCourseView(navigationPath: $navigationPath, viewModel: viewModel)
                    .environmentObject(userAuth)
            }
        }
        
    }
    
    struct CoursesView: View {
        @ObservedObject var viewModel: EstablishmentsViewModel
        @EnvironmentObject var userAuth : UserAuth

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
                    Text("No Courses Managed by You")
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
            
        }
    }
    struct NeedSignupView : View {
        var body: some View {
            VStack(spacing: 250){
                Text("In order to create courses you must\nsubscribe to SubPar's Establishments Package")
                Text("Under Construction")
            }
            .bold(true)
        }
    }
}

#Preview {
    EstablishmentsView(isEstablishment: true, navigationPath: .constant(NavigationPath()))
        .environmentObject(UserAuth().log_in_user(userID: 1))
}
