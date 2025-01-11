//
//  SocialView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI


struct SocialView: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            Text("Social View")
                .font(.largeTitle)

            Button("Go Back") {
                navigationPath.removeLast()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Social")
        .navigationBarBackButtonHidden(true)
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView(navigationPath: .constant(NavigationPath()))
    }
}
