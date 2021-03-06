//
//  NotificationManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/15/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import NotificationCenter
import SwiftUI

class NotificationManager {
    static var center = UNUserNotificationCenter.current()
    
    static func setCategories() {
        // Notification actions
        let deleteAction = UNNotificationAction(identifier: "deleteNotification", title: "Delete Notification", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "deleteCategory", actions: [deleteAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    static func createNotifications(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours, completion: @escaping (Bool, Error?) -> ()) {
        
        // Check if user selections are valid
        if let error = checkErrors(selectedDays: selectedDays, selectedTime: selectedTime, hours: hours) {
            completion(false, error)
            return
        }
        
        // Create notifications for selected days
        for day in selectedDays {
            guard let restaurantTimes = hours.days[day] else {
                // Hours not available for selected times
                // completion(nil, no hours for selected)
                completion(false, NotificationError.NoHours)
                return
            }
            for restaurantTime in restaurantTimes {
                createNotification(restaurant: restaurant, restaurantTime: restaurantTime, selectedTime: selectedTime)
            }
        }
        completion(true, nil)
        return
    }

    static func createNotification(restaurant: Restaurant, restaurantTime: RestaurantTime, selectedTime: DurationPickerTime) {
        setCategories()
        
        // get the closing time
        let dateComponents = DateComponents(hour: Int(restaurantTime.end.prefix(2)), minute: Int(restaurantTime.end.suffix(2)))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        let timeNoFormat = DateComponents(hour: dateComponents.hour, minute: dateComponents.minute)
        let closingTime = dateFormatter.string(from: NSCalendar.current.date(from: timeNoFormat)!)
        
        var closingIn = ""
        if selectedTime.hour > 0 {
            closingIn += "\(selectedTime.hour)hr "
        }
        if selectedTime.minute > 0 {
            closingIn += "\(selectedTime.minute)min"
        } else {
            // remove last space
            closingIn.removeLast()
        }
        
        let content = UNMutableNotificationContent()
        content.title = "\(restaurant.name!)"
        content.body = "Closing in \(closingIn) at \(closingTime)"
        content.categoryIdentifier = "notification"
        content.userInfo = [
            "restaurant_id": restaurant.id,
            "day": restaurantTime.day.dayNum,
            "selectedHour": selectedTime.hour,
            "selectedMinute": selectedTime.minute,
            "name": restaurant.name!,
            "address": restaurant.address!,
            "city": restaurant.city!
        ]
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "deleteCategory"

        let notificationComponents = calculateNotificationTime(restaurantTime: restaurantTime, selectedTime: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    /// Gets all user notifications. Used for debugging
    static func getCurrentNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            completion(requests)
        })
    }
    
    static func calculateNotificationTime(restaurantTime: RestaurantTime, selectedTime: DurationPickerTime) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        
        // arbitrary values to calculate how far back in the day the selected time is
        let startingDay = 3
        let startingDay1Prev = startingDay - 1
        let startingDay2Prev = startingDay - 2

        var endComponents = DateComponents()
        endComponents.hour = Int(restaurantTime.end.prefix(2))
        endComponents.minute = Int(restaurantTime.end.suffix(2))
        endComponents.year = calendar.component(.year, from: Date())
        endComponents.timeZone = .current
        endComponents.day = startingDay // temporaryily used to calculate if weekday has gone back one

        let endDate = calendar.date(from: endComponents)!

        var notificationDate: Date
        notificationDate = calendar.date(byAdding: .hour, value: -1 * selectedTime.hour, to: endDate)!
        notificationDate = calendar.date(byAdding: .minute, value: -1 * selectedTime.minute, to: notificationDate)!
        
        var notificationComponents = calendar.dateComponents([.hour, .minute, .weekday, .timeZone, .year, .day], from: notificationDate)
        
        // for some reason we have to assign the weekday after calculation
        
        // Adjust the weekday once more if the hours were overnight
        // Ex. If restaurant closed at 2am (overnight) on Saturday, and the user asked to be reminded
        // 1 hour before. The notifcation would be 1am on Saturday. This code adjusts it
        // to the proper 1am on Sunday
        // We add this variable in the chunk of code after calculated how much time to go back
        var overnightAdjustment = 0
        if restaurantTime.isOvernight {
            overnightAdjustment = 1
        }
        
        // calculate whether the selected time goes back one day
        if notificationComponents.day == startingDay1Prev { //go back one day
            if restaurantTime.day.dayNum == 1 {
                notificationComponents.weekday = 7
            } else {
                notificationComponents.weekday = restaurantTime.day.dayNum - 1
            }
        } else if notificationComponents.day == startingDay2Prev { //go back two days. Should be the max
            if restaurantTime.day.dayNum == 1 {
                notificationComponents.weekday = 6
            } else {
                notificationComponents.weekday = restaurantTime.day.dayNum - 2
            }
        } else { // still same day
            notificationComponents.weekday = restaurantTime.day.dayNum
        }
        
        // add the overnightAdjustment if necessary here
        if overnightAdjustment == 1 {
            if notificationComponents.weekday == 7 { // If Sunday
                notificationComponents.weekday = 1 // Monday
            } else {
                notificationComponents.weekday! += 1
            }
        }
        
        // make day nil as it was only used to calculate if selected time went back a day
        notificationComponents.day = nil
        notificationComponents.quarter = nil // Bug in Xcode where you have to add this
        return notificationComponents
    }
    
    static func removeNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    private static func checkErrors(selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours) -> Error? {
        if selectedDays.count == 0 {
            return NotificationError.NoSelectedDays
        }
        
        for day in selectedDays {
            guard let restaurantTimes = hours.days[day] else {
                // Hours not available for selected times
                return NotificationError.NoHours
            }
            for restaurantTime in restaurantTimes {
                if restaurantTime.isOvernight == true &&
                    restaurantTime.start == "0000" &&
                    restaurantTime.end == "0000" {
                    // 24 hour day
                    return NotificationError.TwentyFourHours
                }
            }
        }
        
        return nil
    }
}
