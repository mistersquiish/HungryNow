//
//  ColorScheme.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/6/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    static let primary = UIColor(hexString: "FF365")
    static let secondary = UIColor(hexString: "1DB7C")
    static let tertiary = UIColor(hexString: "868686")
    static let fontColor = UIColor(hexString: "EAEAEA")
}


extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F","F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}
