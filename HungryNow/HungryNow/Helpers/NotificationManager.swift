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
    
    static func createRestaurantNotification(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, completion: @escaping
        (Bool, Error?) -> ()) {
        
        YelpAPI.getHours(restaurantID: restaurant.id) { (hours: RestaurantHours?, error: Error?) in
            if let hours = hours {
                // Create notifications for selected days
                for day in selectedDays {
                    guard let restaurantTimes = hours.days[day] else {
                        // Hours not available for selected times
                        // completion(nil, no hours for selected)
                        return
                    }
                    for restaurantTime in restaurantTimes {
                        createNotification(restaurant: restaurant, restaurantTime: restaurantTime, selectedTime: selectedTime)
                    }
                }
                // Save restaurant info and notification id
                CoreDataManager.saveRestaurant(restaurant: restaurant, restaurantHours: hours)
                
                completion(true, nil)
            }
            
            if let error = error {
                completion(false, error)
            }
        }
    }
    
    static func createNotification(restaurant: Restaurant, restaurantTime: RestaurantTime, selectedTime: DurationPickerTime) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "\(restaurant.name!) is closing in \(selectedTime)"
        content.body = "\(restaurant.name!) closes at "
        content.categoryIdentifier = "notification"
        content.userInfo = [
            "restaurant_id": restaurant.id,
            "day": restaurantTime.day.dayNum
        ]
        content.sound = UNNotificationSound.default

        let dateComponents = calculateNotificationTime(restaurantTime: restaurantTime, selectedTime: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // temporary clear notifications
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        getCurrentNotifications() { (requests: [UNNotificationRequest]) in
            for request in requests {
                print(request)
            }
        }
    }
    
    static func getCurrentNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            completion(requests)
        })
    }
    
    static func calculateNotificationTime(restaurantTime: RestaurantTime, selectedTime: DurationPickerTime) -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)

        var endComponents = DateComponents()
        endComponents.hour = Int(restaurantTime.end.prefix(2))
        endComponents.minute = Int(restaurantTime.end.suffix(2))
        endComponents.year = calendar.component(.year, from: Date())
        endComponents.timeZone = .current
        endComponents.day = 3 // temporaryily used to calculate if weekday has gone back one. Arbitrary value

        let endDate = calendar.date(from: endComponents)!

        var notificationDate: Date
        notificationDate = calendar.date(byAdding: .hour, value: -1 * selectedTime.hour, to: endDate)!
        notificationDate = calendar.date(byAdding: .minute, value: -1 * selectedTime.minute, to: notificationDate)!
        
        var notificationComponents = calendar.dateComponents([.hour, .minute, .weekday, .timeZone, .year, .day], from: notificationDate)
        
        // for some reason we have to assign the weekday after calculation
        // calculate whether the selected time goes back one day
        if notificationComponents.day == 2 { //go back one day
            if restaurantTime.day.dayNum == 1 {
                notificationComponents.weekday = 7
            } else {
                notificationComponents.weekday = restaurantTime.day.dayNum - 1
            }
        } else if notificationComponents.day == 1 { //go back two days. Should be the max
            if restaurantTime.day.dayNum == 1 {
                notificationComponents.weekday = 6
            } else {
                notificationComponents.weekday = restaurantTime.day.dayNum - 2
            }
        } else { // still same day
            notificationComponents.weekday = restaurantTime.day.dayNum
        }
        
        // make day nil as it was only used to calculate if selected time went back a day
        notificationComponents.day = nil
        return notificationComponents
    }
    
    static func removeNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}

class Notifications: ObservableObject {
    @Published var notifications = [UNNotificationRequest]()
    
    func getCurrentNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            DispatchQueue.main.async {
                self.notifications = requests
            }
        })
    }
    
    func getNextNotification(restaurantID: String) -> UNNotificationRequest? {

        var restaurantNotifications = notifications.filter { $0.content.userInfo["restaurant_id"] as! String == restaurantID}
        guard restaurantNotifications.count > 0 else { return nil }
        
        
        restaurantNotifications = restaurantNotifications.sorted(by: {
            ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()! >
            ($1.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()!
        })
        
        return restaurantNotifications[0]
    }
    
    func getNotifications(restaurantID: String) -> [UNNotificationRequest] {
        var restaurantNotifications = notifications.filter { $0.content.userInfo["restaurant_id"] as! String == restaurantID}
        
        restaurantNotifications = restaurantNotifications.sorted(by: {
            ($0.trigger as! UNCalendarNotificationTrigger).dateComponents.weekday! >
            ($1.trigger as! UNCalendarNotificationTrigger).dateComponents.weekday!
        })
        
        return restaurantNotifications
    }
}
