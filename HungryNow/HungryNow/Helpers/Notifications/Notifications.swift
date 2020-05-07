//
//  Notifications.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/25/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import NotificationCenter
import SwiftUI

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
            ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()! <
            ($1.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()!
        })
        
        return restaurantNotifications[0]
    }
    
    func getNotifications(restaurantID: String) -> [UNNotificationRequest] {
        var restaurantNotifications = notifications.filter { $0.content.userInfo["restaurant_id"] as! String == restaurantID}

        // There is a bug where sometimes the 'nextTriggerDate()' returns nil. Unsure how that can happen
        restaurantNotifications = restaurantNotifications.sorted(by: {
            ($0.trigger as! UNCalendarNotificationTrigger).nextTriggerDate() ?? Date() <
            ($1.trigger as! UNCalendarNotificationTrigger).nextTriggerDate() ?? Date()
        })
        
        return restaurantNotifications
    }
    
    func removeNotifications(restaurantID: String) {
        let restaurantNotifications = notifications.filter { $0.content.userInfo["restaurant_id"] as! String == restaurantID}
        
        for notification in restaurantNotifications {
            NotificationManager.removeNotification(identifier: notification.identifier)
        }
    }
}
