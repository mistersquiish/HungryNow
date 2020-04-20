//
//  File.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation

class Restaurant: Identifiable {
    var id: String
    var name: String!
    var address: String!
    var city: String!
    var country: String!
    var rating: Float?
    var reviewCount: Int?
    var phone: String?
    var price: String?
    var distance: Float? //(converted to miles)
    var isClosed: Bool?
    var imageURL: String?
    var categories: [[String: String]]!
    var latitude: Double?
    var longitude: Double?
    
    // detailed vars. requires an additional API request
    fileprivate var _hours: RestaurantHours?
    var hours: RestaurantHours? {
        get {
            return _hours
        }
        set {
            _hours = newValue
        }
    }
    
    init(data: [String: Any]) {
        
        id = data["id"] as? String ?? "N/A"
        name = data["name"] as? String ?? "N/A"
        rating = data["rating"] as? Float ?? 0.0
        reviewCount = data["review_count"] as? Int ?? 0
        phone = data["phone"] as? String ?? "No number"
        categories = data["categories"] as? [[String: String]] ?? [["alias": "food",
                                                                    "title": "Food"]]
        price = data["price"] as? String
        
        // convert distance to meters
        var distanceMeters = Measurement(value: data["distance"] as? Double ?? 0.0, unit: UnitLength.meters)
        distance = Float(round(100*distanceMeters.converted(to: UnitLength.miles).value)/100)
        isClosed = data["is_closed"] as? Bool ?? true
        imageURL = data["image_url"] as? String
        
        // Address string
        if let locationInfo = data["location"] as? [String: Any] {
            let city = locationInfo["city"]!
            let state = locationInfo["state"]!
            let address = locationInfo["address1"]!
            
            country = locationInfo["country"]! as? String
            
            self.address = "\(String(describing: address))"
            self.city = "\(String(describing: city)), \(String(describing: state))"
        }
        
        // Coordinates
        if let coordinates = data["coordinates"] as? [String: Double] {
            latitude = coordinates["latitude"]
            longitude = coordinates["longitude"]
            let locManager = LocationManager()
            if let currentLoc = locManager.getCurrentLocation() {
                let restaurantLoc = CLLocation(latitude: latitude!, longitude: longitude!)
                distanceMeters = Measurement(value: currentLoc.distance(from: restaurantLoc), unit: UnitLength.meters)
                distance = Float(round(100*distanceMeters.converted(to: UnitLength.miles).value)/100)
            }
            
        }
    }
    
    init(savedRestaurant: SavedRestaurant) {
        id = savedRestaurant.businessId!
        name = savedRestaurant.name
        phone = savedRestaurant.phone
        price = savedRestaurant.price
        city = savedRestaurant.city
        address = savedRestaurant.address
        country = savedRestaurant.country
        imageURL = savedRestaurant.imageURL
        
        categories = []
        for categoryObject in savedRestaurant.categories! {
            let category: Category = categoryObject as! Category
            let categoryValues = [
                "alias": category.alias!,
                "title": category.title!
            ]
            categories.append(categoryValues)
        }
    }
}

extension Restaurant {
    static func restaurants(dictionaries: [[String: Any]]) -> [Restaurant] {
        var restaurants: [Restaurant] = []
        for dictionary in dictionaries {
            let restaurant = Restaurant(data: dictionary)
            if !restaurant.isClosed! {
                restaurants.append(restaurant)
            }
        }
        
        return restaurants
    }
}
