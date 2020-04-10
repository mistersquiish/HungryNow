//
//  ViewController.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import CoreLocation

class RestaurantVC: UIViewController {
    
    let notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegates
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate

        // Step 1: Ask user for notification permission        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }

//        GoogleAPI.getSearch(query: "Taco Joint")
    }

    
    func makeNotification() {
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Hey I'm a notification!"
        content.body = "Look at me!"
        
        // Step 3: Create the notification trigger
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Step 5: Register the request
        notificationCenter.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
    }
    
}
