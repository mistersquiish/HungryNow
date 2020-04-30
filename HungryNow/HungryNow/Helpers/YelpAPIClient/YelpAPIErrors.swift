//
//  Errors.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum YelpAPIError: Error {
    case RequestFailed(error: Error)
    case NoHours
    case NoBusinesses
    case NoErrorCode
    case AccessLimitReached
    case TooManyRequestsPerSecond
    case ValidationError(responseDescription: String)
    case ValidatinoErrorLocation
    case BusinessNotFound
    // need to add request timed out error
    case Unknown(errorDescription: String)
}

extension YelpAPIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .RequestFailed(let error):
            var errorMessage = error.localizedDescription
            
            if let failureReason = (error as NSError).localizedFailureReason {
                errorMessage = failureReason
            }
            
            return NSLocalizedString("Request failed." + errorMessage, comment: "")
        case .NoHours:
            return NSLocalizedString("Restaurant has no hours listed.", comment: "")
        case .NoBusinesses:
            return NSLocalizedString("No businesses from business search API call.", comment: "")
        case .NoErrorCode:
            return NSLocalizedString("No error code or error description retrieved from API call.", comment: "")
        case .AccessLimitReached:
            return NSLocalizedString("Access limit reached for Yelp API.", comment: "")
        case .TooManyRequestsPerSecond:
            return NSLocalizedString("Too many requests per second. Please try again later.", comment: "")
        case .ValidationError(let responseDescription):
            return NSLocalizedString("Validation error" + responseDescription, comment: "")
        case .ValidatinoErrorLocation:
            return NSLocalizedString("Validation error. Please specify a location or a latitude and longitude.", comment: "")
        case .BusinessNotFound:
            return NSLocalizedString("Business not found from API call.", comment: "")
        case .Unknown(let errorDescription):
            return NSLocalizedString("Unknown Error: " + errorDescription, comment: "")
        }
    }
}
