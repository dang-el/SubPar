//
//  StrokeHistoryView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI


struct StrokeHistoryView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("Stroke History View")
                .font(.largeTitle)

            Button("Go Back") {
                navigationPath.removeLast()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Stroke History")
        .navigationBarBackButtonHidden(true)
    }
}

struct StrokeHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeHistoryView(navigationPath: .constant(NavigationPath()))
    }
}
