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
    
    static let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var updateQueue: [Restaurant] = []
    
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
        savedRestaurant.rating = restaurant.rating ?? 0.0
        savedRestaurant.reviewCount = Int64(restaurant.reviewCount ?? 0)
        savedRestaurant.latitude = restaurant.latitude
        savedRestaurant.longitude = restaurant.longitude
        
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
        for (_, times) in restaurantHours.days {
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
    
    static func addRestaurantToUpdate(savedRestaurant: Restaurant, updatedRestaurant: Restaurant) {
        if savedRestaurant.name != updatedRestaurant.name ||
            savedRestaurant.address != updatedRestaurant.address ||
            savedRestaurant.city != updatedRestaurant.city ||
            savedRestaurant.country != updatedRestaurant.country ||
            savedRestaurant.phone != updatedRestaurant.phone ||
            savedRestaurant.price != updatedRestaurant.price ||
            savedRestaurant.imageURL != updatedRestaurant.imageURL ||
            savedRestaurant.rating != updatedRestaurant.rating ||
            savedRestaurant.reviewCount != updatedRestaurant.reviewCount ||
            savedRestaurant.latitude != updatedRestaurant.latitude ||
            savedRestaurant.longitude != updatedRestaurant.longitude ||
            savedRestaurant.imageURL != updatedRestaurant.imageURL {
            addToQueue(updatedRestaurant: updatedRestaurant)
        }
        
        if savedRestaurant.categories.count != updatedRestaurant.categories.count ||
            savedRestaurant.hours?.days.count != updatedRestaurant.hours?.days.count {
            addToQueue(updatedRestaurant: updatedRestaurant)
        }
        for i in 1...7 {
            if let savedDay = savedRestaurant.hours?.days[Day(rawValue: i)!],
                let updatedDay = updatedRestaurant.hours?.days[Day(rawValue: i)!]{
                if savedDay.count != updatedDay.count {
                    addToQueue(updatedRestaurant: updatedRestaurant)
                }
                
                for j in 0...savedDay.count - 1 {
                    if savedDay[j].day != updatedDay[j].day ||
                        savedDay[j].start != updatedDay[j].start ||
                        savedDay[j].end != updatedDay[j].end ||
                        savedDay[j].isOvernight != updatedDay[j].isOvernight {
                        addToQueue(updatedRestaurant: updatedRestaurant)
                    }
                }
            }
            
        }
    }
    
    private static func addToQueue(updatedRestaurant: Restaurant) {
        print("updated queue")
        updateQueue.append(updatedRestaurant)
        return
    }
    
    static func updateRestaurant(restaurant: Restaurant) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRestaurant")
        request.predicate = NSPredicate(format: "businessId = %@", restaurant.id)
        request.returnsObjectsAsFaults = false
        do {
            let result = try moc.fetch(request)
            // for loop should only ever run once
            for data in result as! [NSManagedObject] {
                data.setValue(restaurant.name, forKey: "name")
                data.setValue(restaurant.address, forKey: "address")
                data.setValue(restaurant.city, forKey: "city")
                data.setValue(restaurant.country, forKey: "country")
                data.setValue(restaurant.phone, forKey: "phone")
                data.setValue(restaurant.price, forKey: "price")
                data.setValue(restaurant.imageURL, forKey: "imageURL")
                data.setValue(restaurant.rating, forKey: "rating")
                data.setValue(restaurant.reviewCount, forKey: "reviewCount")
                data.setValue(restaurant.latitude, forKey: "latitude")
                data.setValue(restaurant.longitude, forKey: "longitude")
                data.setValue(restaurant.imageURL, forKey: "imageURL")
                
                var categories: [Category] = []
                for category in restaurant.categories {
                    let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: moc)
                    let categoryObject = Category(entity: categoryEntity!, insertInto: moc)
                    categoryObject.id = UUID()
                    categoryObject.title = category["title"]
                    categoryObject.alias = category["alias"]
                    categories.append(categoryObject)
                }
                data.setValue(NSSet.init(array: categories), forKey: "categories")
                
                if let hours = restaurant.hours {
                    var savedTimes: [SavedTime] = []
                    for (_, times) in hours.days {
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
                    data.setValue(NSSet.init(array: savedTimes), forKey: "savedTimes")
                }
                try? moc.save()
            }
        } catch {
            
            print("Failed")
        }
    }
}
