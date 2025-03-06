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
    @StateObject var viewModel : EstablishmentsViewModel = EstablishmentsViewModel()
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
                        if(viewModel.Establishments.count != 0){
                            ContentView(navigationPath: $navigationPath)
                                
                                
                        }
                        else{
                            Text("No Establishments to Fetch")
                                .foregroundStyle(.quaternary)
                                .padding(.top, 125)
                        }
                    }
                    else{
                        NeedSignupView()
                    }
                }
                .padding()
                
                
                
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
    
    struct ContentView : View {
        @Binding var navigationPath : NavigationPath
        @EnvironmentObject var userAuth : UserAuth
        var body: some View {
            Text("Top of")
            ScrollView{
                Text("Scrollview")
            }
            Text("Bottom of")
            
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
}
