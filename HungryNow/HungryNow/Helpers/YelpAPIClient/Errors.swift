//
//  Errors.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum YelpAPIError: Error {
    case NoHours
}

extension YelpAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NoHours:
            return NSLocalizedString("No hours retrieved from business detail API call", comment: "")
        }
    }
}
