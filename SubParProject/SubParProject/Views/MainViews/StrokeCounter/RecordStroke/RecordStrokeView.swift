import SwiftUI

struct RecordStrokeView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var viewModel = RecordStrokeViewModel()
    @EnvironmentObject var userAuth: UserAuth
    
   
                

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:
                                                [Color(red: 115/255, green: 185/255, blue: 115/255),
                                                 Color(red: 115/255, green: 175/255, blue: 100/255),
                                                 Color(red: 115/255, green: 200/255, blue: 200/255),
                                                 Color(red: 0/255, green: 200/255, blue: 255/255),
                                                 Color(red: 255/255, green: 255/255, blue: 165/255)]),
                           startPoint: .bottom,
                           endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Record Stroke")
                    .font(.system(size: 50, weight: .bold))
                    .padding(.top, 10)
                
                Spacer() 
                Record_Stroke_Input_Panel(viewModel: viewModel)
                Spacer()
                
                Button {
                    // Ask the view model to record a stroke in the database
                    Task{
                        try await viewModel.recordStroke(userAuth: userAuth)
                    }
                    
                } label: {
                    Text("Record Stroke To Database")
                        .font(.system(size: 25))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct Record_Stroke_Input_Panel: View {
    @State private var selectedOption = 0
    @ObservedObject var viewModel : RecordStrokeViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Dropdown Panel
            Picker("Select Option", selection: $viewModel.selectedOption) {
                ForEach(0..<viewModel.getClubOptions().count, id: \.self) { index in
                    Text(viewModel.getClubOptions()[index])
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .padding(.bottom, 20)
            // Number Input 1
            TextField("Approximate Distance Hit", text: $viewModel.distance)
                .keyboardType(.numberPad) // Allow only numbers
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .padding(.horizontal)

            // Number Input 2
            TextField("Shot Rating (1-10)", text: $viewModel.rating)
                .keyboardType(.numberPad) // Allow only numbers
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .padding(.horizontal)
        }
    }
}

struct RecordStrokeView_Previews: PreviewProvider {
    static var previews: some View {
        RecordStrokeView(navigationPath: .constant(NavigationPath()))
            
    }
}
