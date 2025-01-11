//
//  UploadScorecardView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI


struct UploadScorecardView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("Upload Scorecard View")
                .font(.largeTitle)

            Button("Go Back") {
                navigationPath.removeLast()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Upload Scorecard")
        .navigationBarBackButtonHidden(true)
    }
}

struct UploadScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        UploadScorecardView(navigationPath: .constant(NavigationPath()))
    }
}
