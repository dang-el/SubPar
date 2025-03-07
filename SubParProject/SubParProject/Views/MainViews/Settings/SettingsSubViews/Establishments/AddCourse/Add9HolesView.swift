    //
//  Add9HolesView.swift
//  SubParProject
//
//  Created by Owen Dangel on 3/4/25.
//

import SwiftUI

struct Add9HolesView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel: EstablishmentsViewModel
    @EnvironmentObject var userAuth : UserAuth
    var body: some View {
        ZStack {
            // Full-screen gradient background
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue:115/255),
                                                 Color(red: 115/255, green: 175/255, blue:100/255),
                                                 Color(red: 115/255, green: 200/255, blue:200/255),
                                                 Color(red: 0/255, green: 200/255, blue:255/255),
                                                 Color(red:255/255, green:255/255, blue:165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all) // This will cover the entire screen including the top and bottom
            
            // The TabView itself
            TabView {
                InformationView()
                
                ForEach(1...9, id: \.self) { index in
                    CreateHoleView(navigationPath: $navigationPath, holeNumber: index, viewModel: viewModel)
                }
                
                SubmitCourseView(viewModel: viewModel, navigationPath: $navigationPath)
                
                    
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)  // Ensure the TabView spans the whole screen
            .statusBar(hidden: true)      // Hide status bar
            .navigationBarHidden(true)   // Hide navigation bar to prevent unwanted spacing
        }
    }

    struct CreateHoleView : View {
        @Binding var navigationPath : NavigationPath
        var holeNumber : Int
        @StateObject var viewModel : EstablishmentsViewModel
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
                    Text("Hole \(holeNumber)")
                        .font(.largeTitle)
                        .bold()
                    HoleContentView(viewModel: viewModel, holeNumber: holeNumber)
                        .padding(.top, 50)
                    Spacer()
                    StyledButton(title: "Go Back", isPrimary: true) {
                        navigationPath.removeLast()
                    }
                    .frame(width: 255)
                    .padding(.bottom, 25)
                }
                .padding()
            }
            
        }
        struct HoleContentView: View { // LMAO
            @StateObject var viewModel : EstablishmentsViewModel
            var holeNumber: Int
            var body: some View {
                    VStack(spacing: 45) {
                        HStack {
                            Text("Par")
                                .bold()
                                .font(.title)
                            Spacer()
                            TextField("Par", text: $viewModel.holes[holeNumber - 1].par)
                                .frame(width: 75)
                                .font(.title)
                                .multilineTextAlignment(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            Text("Yardage")
                                .bold()
                                .font(.title)
                            Spacer()
                            TextField("Yardage", text: $viewModel.holes[holeNumber - 1].yardage)
                                .frame(width: 125)
                                .font(.title)
                                .multilineTextAlignment(.trailing)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Brief Hole Summary (Recommended)")
                                .font(.title)
                                .bold()
                            TextEditor(text: $viewModel.holes[holeNumber - 1].description)
                                .padding()
                                .background(Color.clear)
                                .scrollContentBackground(.hidden)
                                .frame(maxWidth: .infinity, minHeight: 100)
                                .cornerRadius(8)
                                .foregroundColor(.primary)
                        }
                    }
                    .onAppear(perform: {
                        viewModel.holes[holeNumber-1].holeNumber = "\(holeNumber)"
                    })
                    .padding(.horizontal)
                }
        }

    }
    struct InformationView : View {
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
                    Text("Information")
                        .font(.largeTitle)
                        .bold()
                    //display information for how to use this system on the title slide
                    InformationContentView()
                        .padding(.top, 30)
                    Spacer()
                    Text("Thank you for your Support")
                        .foregroundStyle(.quaternary)
                        .padding()
                }
                .padding()
            }
            
        }
        struct InformationContentView : View {
            var body: some View {
                Text("How to Add 9 Holes to Your Course")
                    .font(.title3)
                    .fontWeight(.bold)
                    
                    
                VStack(alignment: .leading, spacing: 35){
                    Text("• Swipe to Navigate to the Next Hole")
                        .bold()
                    Text("• Fill in All Hole Data")
                        .bold()
                    Text("• Ensure All Possible Fields Are Filled")
                        .bold()
                    Text("• Invalid Entries Will Cause Failure of Upload")
                        .bold()
                    Text("• Swipe to the Final Page to Submit Course")
                        .bold()
                    Text("• If All Information is Good, Course Will Upload")
                        .bold()
                    Text("• Once 'Course Upload Sucessful' is Displayed, Feel Free to 'Go Back'")
                        .bold()
                    Text("• If No Summary is Provided, the Sample Data WILL NOT Be Stored Instead")
                        .bold()
                    Text("• Par And Yardage MUST BE SUPPLIED For All 9 Holes")
                        .bold()
                    
                }
                
            }
        }
    }
    struct SubmitCourseView : View {
        @StateObject var viewModel : EstablishmentsViewModel
        @Binding var navigationPath : NavigationPath
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
                    Text("Submit Course")
                        .font(.largeTitle)
                        .bold()
                    if(viewModel.messageFromServer != ""){
                        Text(viewModel.messageFromServer)
                            .padding(.top, 20)
                    }
                    else{
                        EmptyView()
                    }
                    
                        
                    Spacer()
                    ContentView(viewModel: viewModel)
                        .padding()
                    Spacer()
                    VStack(spacing: 55){
                        StyledButton(title: "Upload All Course Data") {
                            Task{
                                try await viewModel.uploadCourse(userAuth: userAuth)
                            }
                            
                        }
                        
                        StyledButton(title: "Go Back", isPrimary: true) {
                            navigationPath.removeLast()
                        }
                        
                    }
                    .padding(.bottom, 25)
                    .frame(width: 255)
                }
                .padding()
            }
        }
        struct ContentView : View {
            @StateObject var viewModel : EstablishmentsViewModel
            var body: some View {
                VStack(spacing: 75){
                    HStack{
                        Text("Course Name")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(viewModel.courseName)
                    }
                    //
                    HStack{
                        Text("Established")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(viewModel.dateEstablished)
                    }
                    //
                    HStack{
                        Text("Slope Rating")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text(viewModel.slopeRating)
                    }
                }
            }
        }
    }
}


#Preview {
    Add9HolesView(navigationPath: .constant(NavigationPath()), viewModel: EstablishmentsViewModel())
}
