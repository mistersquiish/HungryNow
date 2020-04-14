//
//  Hours.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

class Hours {
    var days: [Int: [Time]] = [:]
    
    init(times: [[String: Any]]) {
        for timeData in times {
            let time = Time(timeData: timeData)
            
            if days[time.day] == nil {
                days[time.day] = [time]
            } else {
                days[time.day]!.append(time)
            }
            
        }
    }
    
    init() {
        days[-1] = [Time()]
    }
}

class Time {
    var isOvernight: Bool
    var start: Int
    var end: Int
    var day: Int
    
    init(timeData: [String: Any]) {
        self.isOvernight = timeData["is_overnight"] as! Bool
        self.start = Int(timeData["start"] as! String)!
        self.end = Int(timeData["end"] as! String)!
        self.day = timeData["day"] as! Int
    }
    
    init() {
        self.isOvernight = true
        self.start = -1
        self.end = -1
        self.day = -1
    }
}
