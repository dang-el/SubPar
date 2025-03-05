//
//  EstablishmentsViewModel.swift
//  SubParProject
//
//  Created by Owen Dangel on 2/28/25.
//

import Foundation

@MainActor
final class EstablishmentsViewModel : ObservableObject {
    @Published var holes: [HoleData] = Array(repeating: HoleData(), count: 9)
    @Published var courseName = ""
    @Published var dateEstablished = ""
    @Published var slopeRating = ""
    @Published var Establishments : [EstablishmentsResponse] = []
    struct HoleData {
        var par: String = ""
        var yardage: String = ""
        var description: String = """
Your Summary Here... (<- to save summary delete all text and write new.  -v  )

The par for this hole is 4, with a slight dogleg to the right.
            Fairway bunkers on the left side require precision off the tee.
            Approach shot needs to carry the front bunker to reach the green.
            Beware of the slope on the right side of the green!
"""
    }
    struct EstablishmentsResponse {
        var name: String
    }
    enum EstablishmentsDestination : Hashable {
        case addCourse
    }
    enum AddCourseDestination : Hashable {
        case add9Holes
    }
    func uploadCourse() async throws {
        print("uploading \(self.courseName), \(self.dateEstablished), \(self.slopeRating)...")
    }
}
