//
//  DayButton.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/7/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct DayButton: View {
    
    let day: String
    @Binding var toggled: Bool
    @State var buttonBackground = Color("background2")
    @State var buttonTint = Color("font")

    var body: some View {
        Button(action: {
            self.toggled.toggle()
            if self.toggled {
                self.buttonBackground = Color("accent")
                self.buttonTint = Color("background")
            } else {
                self.buttonBackground = Color("background2")
                self.buttonTint = Color("font")
            }
        }) {
            Text(day)
                .font(.system(size: 18))
                .padding(12)
                .background(buttonBackground)
                .foregroundColor(buttonTint)
                .mask(Circle())
        }
    }
}


