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
    
    var previousDay: Day {
        switch self {
        case .Sunday:
            return .Saturday
        case .Monday:
            return .Sunday
        case .Tuesday:
            return .Monday
        case .Wednesday:
            return .Tuesday
        case .Thursday:
            return .Wednesday
        case .Friday:
            return .Thursday
        case .Saturday:
            return .Friday
        }
    }
    
    var nextDay: Day {
        switch self {
        case .Sunday:
            return .Monday
        case .Monday:
            return .Tuesday
        case .Tuesday:
            return .Wednesday
        case .Wednesday:
            return .Thursday
        case .Thursday:
            return .Friday
        case .Friday:
            return .Saturday
        case .Saturday:
            return .Sunday
        }
    }
}

class RestaurantHours {
    var days: [Day: [RestaurantTime]] = [:]
    
    lazy var isOpen: Bool = {
        calculateIsOpen()
    }()
    var nextClosingTime: Date? // calculated by calculateIsOpen() method
    
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
    
    private func calculateIsOpen() -> Bool {
        // get current time
        let currentDate = Date()
        let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: currentDate)
        
        // get time intervals for current day
        let currentDayHours = getDateIntervals(day: Day(rawValue: currentDateComponents.weekday!)!, previousDay: false)
        
        // check if the current day hours encompass current time
        for dates in currentDayHours {            
            if dates[0] < currentDate && currentDate < dates[1] {
                nextClosingTime = dates[1]
                return true
            }
        }
                
        // get time intervals for previous day
        let previousDayHours = getDateIntervals(day: Day(rawValue: currentDateComponents.weekday!)!.previousDay, previousDay: true)

        // check if the previous day hours encompass current time
        for dates in previousDayHours {
            if dates[0] < currentDate && currentDate < dates[1] {
                nextClosingTime = dates[1]
                return true
            }
        }
        
        return false
    }
    
    /// Should return sets of 2 dates that represent a start and end time
    private func getDateIntervals(day: Day, previousDay: Bool) -> [[Date]] {
        // get current time
        let calendar = Calendar(identifier: .gregorian)
        var date = Date()
        if previousDay {
            var dayComponent = DateComponents()
            dayComponent.day = -1
            let currentCalendar = Calendar.current
            date = currentCalendar.date(byAdding: dayComponent, to: date)!
        }
        
        var dates: [[Date]] = []
        
        if let hours = self.days[day] {
            for time in hours {
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: date)
                
                // create date of opening
                dateComponents.hour = Int(time.start.prefix(2))
                dateComponents.minute = Int(time.start.suffix(2))
                let startingDate = calendar.date(from: dateComponents)!
                
                // create date of closing
                dateComponents.hour = Int(time.end.prefix(2))
                dateComponents.minute = Int(time.end.suffix(2))
                var closingDate = calendar.date(from: dateComponents)!
                
                // adjust closing day if hours are overnight
                if time.isOvernight {
                    var dayComponent = DateComponents()
                    dayComponent.day = 1
                    let currentCalendar = Calendar.current
                    closingDate = currentCalendar.date(byAdding: dayComponent, to: closingDate)!
                }
                
                dates.append([startingDate, closingDate])
            }
        }
        return dates
    }
}

class RestaurantTime: Identifiable {
    let id = UUID()
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
