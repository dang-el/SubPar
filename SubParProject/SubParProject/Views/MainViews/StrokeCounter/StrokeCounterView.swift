//
//  StrokeCounterView.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/10/25.
//

import SwiftUI

enum NavigationDestination {
    case recordStroke
}

struct StrokeCounterView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject var viewModel = StrokeCounterViewModel()
    @EnvironmentObject var userAuth: UserAuth

    var body: some View {
        ZStack {
            Stroke_Counter_View_Gradient()
            VStack {
                Spacer()
                Stroke_Adder_View()
                Spacer()
                Record_Stroke_View(navigationPath: $navigationPath)
                Spacer()
                Button("Go Back") {
                    navigationPath.removeLast()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .recordStroke:
                RecordStrokeView(navigationPath: $navigationPath) // New view for "Record Stroke"
                    .environmentObject(userAuth)
            }
        }
    }
}

struct Record_Stroke_View: View {
    @Binding var navigationPath: NavigationPath

    var body: some View {
        Button {
            navigationPath.append(NavigationDestination.recordStroke)
        } label: {
            Text("Record Stroke")
                .font(.system(size: 25))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}


struct Stroke_Adder_View: View {
    @State private var stroke_count: Int = 0

    var body: some View {
        VStack(spacing: 75) {
            Text("Stroke Counter: \(stroke_count)")
                .font(.system(size: 30))
            VStack {
                Button {
                    print("Adding 1 to stroke counter")
                    stroke_count += 1
                } label: {
                    Text("+")
                        .font(.system(size: 100))
                }
                Button {
                    if stroke_count >= 1 {
                        print("Subtracting 1 from stroke counter")
                        stroke_count -= 1
                    }
                } label: {
                    Text("-")
                        .font(.system(size: 100))
                }
            }
        }
    }
}

struct Stroke_Counter_View_Gradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 115 / 255, green: 185 / 255, blue: 115 / 255),
                Color(red: 115 / 255, green: 175 / 255, blue: 100 / 255),
                Color(red: 115 / 255, green: 200 / 255, blue: 200 / 255),
                Color(red: 0 / 255, green: 200 / 255, blue: 255 / 255),
                Color(red: 255 / 255, green: 255 / 255, blue: 165 / 255)
            ]),
            startPoint: .bottom,
            endPoint: .topTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct StrokeCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeCounterView(navigationPath: .constant(NavigationPath()))
    }
}
