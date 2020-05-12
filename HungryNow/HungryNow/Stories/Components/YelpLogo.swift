//
//  YelpLogo.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct YelpLogo: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("yelp")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 60, maxHeight: 40)
                .padding().onTapGesture {
                    if let url = URL(string: "https://www.yelp.com/") {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}

struct YelpRating: View {
    var ratingImage: Image
    
    init(rating: Float) {
        if rating == 5 {
            ratingImage = Image("small_5")
        } else if rating >= 4.5 {
            ratingImage = Image("small_4_half")
        } else if rating >= 4 {
            ratingImage = Image("small_4")
        } else if rating >= 3.5 {
            ratingImage = Image("small_3_half")
        } else if rating >= 3 {
            ratingImage = Image("small_3")
        } else if rating >= 2.5 {
            ratingImage = Image("small_2_half")
        } else if rating >= 2 {
            ratingImage = Image("small_2")
        } else if rating >= 1.5 {
            ratingImage = Image("small_1_half")
        } else if rating >= 1 {
            ratingImage = Image("small_1")
        } else {
            ratingImage = Image("small_0")
        }
    }
    
    var body: some View {
        ratingImage.resizable()
    }
}
