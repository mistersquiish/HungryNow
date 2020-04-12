//
//  Errors.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum YelpAPIError: Error {
    case NotRestaurant
}

extension YelpAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotRestaurant:
            return NSLocalizedString("Tried to make a restaurant object with non-restaurant place", comment: "")
        }
    }
}
