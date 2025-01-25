//
//  GolferProfile.swift
//  SubParProject
//
//  Created by Owen Dangel on 1/25/25.
//

import SwiftUI

struct GolferProfile: View {
    var golfer: AddFriendsViewModel.GolferResponse
    var body: some View {
        VStack{
            Text("\(golfer.Username)'s Profile")
            Spacer()
        }
        
        
        
    }
}

struct GolferProfile_Previews: PreviewProvider {
    static var previews: some View {
        GolferProfile(golfer: AddFriendsViewModel.GolferResponse(Golfer_ID: 1,Username: "owendangel4096"))
    }
}
