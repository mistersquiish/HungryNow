//
//  PageView.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/14/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct PageView: View {
    var title: String
    var imageName: String
    var header: String
    var content: String
    var textColor: Color

    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350

    var body: some View {
        let size = UIImage(named: imageName)!.size
        let aspect = size.width / size.height

        return
            VStack(alignment: .center, spacing: 50) {
                Text(header)
                    .font(Font.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(textColor)
                    .frame(width: textWidth)
                    .multilineTextAlignment(.center)
                Image(imageName)
                    .resizable()
                    .aspectRatio(aspect, contentMode: .fill)
                    .frame(width: imageWidth, height: imageWidth)
                    .cornerRadius(40)
                    .clipped()
                VStack(alignment: .center, spacing: 5) {
//                    Text(header)
//                        .font(Font.system(size: 25, weight: .bold, design: .rounded))
//                        .foregroundColor(textColor)
//                        .frame(width: 300, alignment: .center)
//                        .multilineTextAlignment(.center)
                    Text(content)
                        .font(Font.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(textColor)
                        .frame(width: 300, alignment: .center)
                        .multilineTextAlignment(.center)
                }
            }.padding(60)
    }
}

struct TutorialData {
    static let title = "How it works"
    static let headers = [
        "Step 1",
        "Step 2",
        "Step 3",
        "Step 4",
    ]
    static let contentStrings = [
        "Find your favorite restaurant.",
        "Select how much time before closing you want to be notified by.",
        "Hit Save.",
        "All set! You'll be notified at your exact time."
    ]
    static let imageNames = [
        "tutorial_1",
        "tutorial_2",
        "tutorial_3",
        "tutorial_4"
    ]

    static let colors = [
        "455CFF",
        "FFDE73",
        "3366CC",
        "FF5900"
        ].map{ Color(hex: $0) }

    static let textColors = [
        "FFFFFF",
        "000000",
        "FFFFFF",
        "FFFFFF"
        ].map{ Color(hex: $0) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff


        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
