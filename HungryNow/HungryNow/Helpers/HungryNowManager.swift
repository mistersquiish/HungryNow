//
//  HungryNowManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/25/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

class HungryNowManager {
    
    static func addNewRestaurant(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, completion: @escaping
        (Bool, Error?) -> ()) {
        
        YelpAPI.getHours(restaurantID: restaurant.id) { (hours: RestaurantHours?, error: Error?) in
            if let hours = hours {
                createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours)
                
                // Save restaurant info and notification id
                CoreDataManager.saveRestaurant(restaurant: restaurant, restaurantHours: hours)
                
                completion(true, nil)
            }
            
            if let error = error {
                completion(false, error)
            }
        }
    }
    
    static func addNotification(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours) {
        createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours)
    }
    
    private static func createNotifications(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours) {
        // Create notifications for selected days
        for day in selectedDays {
            guard let restaurantTimes = hours.days[day] else {
                // Hours not available for selected times
                // completion(nil, no hours for selected)
                return
            }
            for restaurantTime in restaurantTimes {
                NotificationManager.createNotification(restaurant: restaurant, restaurantTime: restaurantTime, selectedTime: selectedTime)
            }
        }
    }
}
