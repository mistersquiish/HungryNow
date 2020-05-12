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
