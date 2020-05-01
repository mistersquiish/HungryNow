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
    case LocationNotEnabled
    case NotificationNotEnabled
    case AlreadySaved
}

extension NotificationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .TwentyFourHours:
            return NSLocalizedString("Restaurant is 24 hours for selected days.", comment: "")
        case .NoHours:
            return NSLocalizedString("Restaurant has no hours for selected days.", comment: "")
        case .NoSelectedDays:
            return NSLocalizedString("Please select a day.", comment: "")
        case .LocationNotEnabled:
            return NSLocalizedString("Location not enabled. Please enable location.", comment: "")
        case .NotificationNotEnabled:
            return NSLocalizedString("Notifications not enabled. Please enable notifications.", comment: "")
        case .AlreadySaved:
            return NSLocalizedString("Restaurant has already been added. Please add additional notifications in the home screen.", comment: "")
        }
        
    }
}
