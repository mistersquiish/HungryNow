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
                NotificationManager.createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours) { (error: Error?) in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    // Save restaurant info and notification id
                    CoreDataManager.saveRestaurant(restaurant: restaurant, restaurantHours: hours)
                    
                    completion(true, nil)
                }
            }
            
            if let error = error {
                completion(false, error)
            }
        }
    }
    
    static func addNotification(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours, completion: @escaping (Bool, Error?) -> ()) {
        NotificationManager.createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours) { (error: Error?) in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    
}
