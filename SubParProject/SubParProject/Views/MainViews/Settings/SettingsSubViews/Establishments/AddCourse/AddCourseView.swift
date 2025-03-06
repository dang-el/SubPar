//
//  AddCourseView.swift
//  SubParProject
//
//  Created by Owen Dangel on 3/1/25.
//

import SwiftUI

struct AddCourseView: View {
    @Binding var navigationPath : NavigationPath
    @StateObject var viewModel : EstablishmentsViewModel
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
            VStack(spacing: 105){
                VStack{
                    Text("Add Course")
                        .font(.largeTitle)
                        .bold()
                    Text("If Your Couse Has 18 or More Holes Seperate Over Multiple Courses")
                        .foregroundStyle(.quaternary)
                        .bold()
                        .padding(.top, 30)
                }
                
                ContentView(navigationPath : $navigationPath, viewModel: viewModel)
                    .padding(.top)
                Spacer()
                StyledButton(title: "Go Back", isPrimary: true) {
                    navigationPath.removeLast()
                }
                .frame(width: 255)
                
            }
            .padding()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: EstablishmentsViewModel.AddCourseDestination.self) { destination in
            switch destination {
                case .add9Holes:
                Add9HolesView(navigationPath: $navigationPath, viewModel: viewModel)
                    .environmentObject(userAuth)
            }
        }
        
    }
    struct ContentView : View {
        @Binding var navigationPath : NavigationPath
        @StateObject var viewModel : EstablishmentsViewModel
        var body: some View {
            VStack(spacing: 45){
                HStack{
                    Text("Course Name")
                        .bold()
                    Spacer()
                    TextField("Enter Course Name", text: $viewModel.courseName)
                        .frame(width: 200)
                }
                HStack{
                    Text("Year Established")
                        .bold()
                    Spacer()
                    TextField("Enter Year (MM/DD/YYYY)", text: $viewModel.dateEstablished )
                        .frame(width: 200)
                }
                HStack{
                    Text("Slope Rating")
                        .bold()
                    Spacer()
                    TextField("Slope Rating", text: $viewModel.slopeRating)
                        .frame(width: 200)
                }
                if(viewModel.courseName != "" && viewModel.dateEstablished != "" && viewModel.slopeRating != ""){
                    StyledButton(title: "Add 9 Holes") {
                        navigationPath.append(EstablishmentsViewModel.AddCourseDestination.add9Holes)
                    }
                    .padding(.top, 45)
                    .frame(width: 255)
                }
                
                
            }
        }
    }
}



#Preview {
    AddCourseView(navigationPath: .constant(NavigationPath()), viewModel: EstablishmentsViewModel())
}
