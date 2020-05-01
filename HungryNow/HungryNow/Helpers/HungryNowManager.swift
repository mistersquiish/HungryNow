//
//  HungryNowManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/25/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import UserNotifications

class HungryNowManager {
    
    static func addNewRestaurant(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, completion: @escaping
        (Bool, Error?) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print(error)
                completion(false, error)
            }
            
            if granted {
                YelpAPI.getHours(restaurantID: restaurant.id) { (hours: RestaurantHours?, error: Error?) in
                    if let hours = hours {
                        NotificationManager.createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours) { (success: Bool, error: Error?) in
                            if success {
                                // Save restaurant info and notification id
                                CoreDataManager.saveRestaurant(restaurant: restaurant, restaurantHours: hours)
                                
                                completion(true, nil)
                            } else {
                                if let error = error {
                                    completion(false, error)
                                    return
                                }
                            }
                            
                            
                        }
                    }
                    
                    if let error = error {
                        completion(false, error)
                    }
                }
            } else {
                completion(false, NotificationError.NotificationNotEnabled)
            }
        }
        
    }
    
    static func addNotification(restaurant: Restaurant, selectedDays: [Day], selectedTime: DurationPickerTime, hours: RestaurantHours, completion: @escaping (Bool, Error?) -> ()) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print(error)
                completion(false, error)
            }
            
            if granted {
                NotificationManager.createNotifications(restaurant: restaurant, selectedDays: selectedDays, selectedTime: selectedTime, hours: hours) { (success: Bool, error: Error?) in
                    if success {
                        completion(true, nil)
                    } else {
                        if let error = error {
                            completion(false, error)
                        }
                    }
                }
            } else {
                completion(false, NotificationError.NotificationNotEnabled)
            }
        }
        
        
    }
    
    
}
