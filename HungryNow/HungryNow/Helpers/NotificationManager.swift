//
//  NotificationManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/15/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import NotificationCenter

class NotificationManager {
    static func createRestaurantNotification(restaurantID: String, selectedDays: [Day], selectedTime: DurationPickerTime, completion: @escaping
        (Bool, Error?) -> ()) {
        
        YelpAPI.getHours(restaurantID: restaurantID) { (hours: RestaurantHours?, error: Error?) in
            if let hours = hours {
//                for (day, restaurantTimes) in hours.days {
//                    for restaurantTime in restaurantTimes {
//                        print(day)
//                        print(restaurantTime.start)
//                        print(restaurantTime.end)
//                        print("----")
//                        completion(true, nil)
//                    }
//                }
                // Create notifications for selected days
                for day in selectedDays {
                    guard let restaurantTimes = hours.days[day] else {
                        // Hours not available for selected times
                        // completion(nil, no hours for selected)
                        return
                    }
                    for restaurantTime in restaurantTimes {
                        createNotification(day: day, time: restaurantTime, selectedTime: selectedTime)
                        print(day)
                    }
                }
                
                completion(true, nil)
            }
            
            if let error = error {
                completion(true, error)
            }
        }
    }
    
    static func createNotification(day: Day, time: RestaurantTime, selectedTime: DurationPickerTime) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 17
        dateComponents.minute = 59
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        getCurrentNotifications()
    }
    
    static func getCurrentNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
    }
}
