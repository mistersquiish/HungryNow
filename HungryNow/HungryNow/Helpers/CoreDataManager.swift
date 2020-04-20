//
//  CoreDataManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/19/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static func saveRestaurant(restaurant: Restaurant, restaurantHours: RestaurantHours) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let savedRestaurants = NSEntityDescription.entity(forEntityName: "SavedRestaurant", in: moc)
        let savedRestaurant = SavedRestaurant(entity: savedRestaurants!, insertInto: moc)
        
        
        savedRestaurant.id = UUID()
        savedRestaurant.name = restaurant.name
        savedRestaurant.address = restaurant.address
        savedRestaurant.businessId = restaurant.id
        savedRestaurant.city = restaurant.city
        savedRestaurant.country = restaurant.country
        savedRestaurant.phone = restaurant.phone
        savedRestaurant.price = restaurant.price
        savedRestaurant.imageURL = restaurant.imageURL
        
        var categories: [Category] = []
        for category in restaurant.categories {
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: moc)
            let categoryObject = Category(entity: categoryEntity!, insertInto: moc)
            categoryObject.id = UUID()
            categoryObject.title = category["title"]
            categoryObject.alias = category["alias"]
            categories.append(categoryObject)
        }
        savedRestaurant.categories = NSSet.init(array: categories)
        
        var savedTimes: [SavedTime] = []
        for (day, times) in restaurantHours.days {
            for time in times {
                let hourEntity = NSEntityDescription.entity(forEntityName: "SavedTime", in: moc)
                let hourObject = SavedTime(entity: hourEntity!, insertInto: moc)
                hourObject.id = UUID()
                hourObject.start = time.start
                hourObject.end = time.end
                hourObject.isOvernight = time.isOvernight
                hourObject.day = Int16(time.day.dayNum)
                savedTimes.append(hourObject)
            }
            
        }
        savedRestaurant.savedTimes = NSSet.init(array: savedTimes)

        try? moc.save()
    }
}
