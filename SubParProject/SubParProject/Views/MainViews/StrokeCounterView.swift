//
//  StrokeCounterView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI

struct StrokeCounterView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("Stroke Counter View")
                .font(.largeTitle)

            Button("Go Back") {
                navigationPath.removeLast()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Stroke Counter")
        .navigationBarBackButtonHidden(true)
    }
}

struct StrokeCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeCounterView(navigationPath: .constant(NavigationPath()))
    }
}
