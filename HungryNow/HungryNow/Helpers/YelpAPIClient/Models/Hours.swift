//
//  Hours.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

enum Day {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
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
    var start: Int
    var end: Int
    var day: Day
    
    init(timeData: [String: Any]) {
        self.isOvernight = timeData["is_overnight"] as! Bool
        self.start = Int(timeData["start"] as! String)!
        self.end = Int(timeData["end"] as! String)!
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
}
