//
//  Hours.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum Day: Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
    var dayNum: Int {
        switch self {
        case .Sunday:
            return 1
        case .Monday:
            return 2
        case .Tuesday:
            return 3
        case .Wednesday:
            return 4
        case .Thursday:
            return 5
        case .Friday:
            return 6
        case .Saturday:
            return 7
        }
        
    }
}

class RestaurantHours {
    var days: [Day: [RestaurantTime]] = [:]
    
    init(times: [[String: Any]]) {
        for timeData in times {
            let time = RestaurantTime(timeData: timeData)
            
            if days[time.day] == nil {
                days[time.day] = [time]
            } else {
                days[time.day]!.append(time)
            }
            
        }
    }
    
    init() { }
}

class RestaurantTime {
    var isOvernight: Bool
    var start: String
    var end: String
    var day: Day
    
    init(timeData: [String: Any]) {
        self.isOvernight = timeData["is_overnight"] as! Bool
        self.start = timeData["start"] as! String
        self.end = timeData["end"] as! String
        let dayNum = timeData["day"] as! Int
        switch dayNum {
        case 0:
            self.day = Day.Monday
        case 1:
            self.day = Day.Tuesday
        case 2:
            self.day = Day.Wednesday
        case 3:
            self.day = Day.Thursday
        case 4:
            self.day = Day.Friday
        case 5:
            self.day = Day.Saturday
        default:
            self.day = Day.Sunday
        }
    }
    
    init(savedTime: SavedTime) {
        self.isOvernight = savedTime.isOvernight
        self.start = savedTime.start!
        self.end = savedTime.end!
        let dayNum = savedTime.day
        switch dayNum {
        case 1:
            self.day = Day.Sunday
        case 2:
            self.day = Day.Monday
        case 3:
            self.day = Day.Tuesday
        case 4:
            self.day = Day.Wednesday
        case 5:
            self.day = Day.Thursday
        case 6:
            self.day = Day.Friday
        default:
            self.day = Day.Saturday
        }
    }
}
