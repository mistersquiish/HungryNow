//
//  NotificationErrors.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/25/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum NotificationError: Error {
    case TwentyFourHours
    case NoHours
    case NoSelectedDays
}

extension NotificationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .TwentyFourHours:
            return NSLocalizedString("Restaurant is 24hours", comment: "")
        case .NoHours:
            return NSLocalizedString("Restaurant has no hours", comment: "")
        case .NoSelectedDays:
            return NSLocalizedString("User selected no days", comment: "")
        }
        
    }
}
