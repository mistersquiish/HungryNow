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

struct Restaurant: Identifiable {
    var id: String
    var name: String!
    var address: String!
    var city: String!
    var rating: Float!
    var reviewCount: Int!
    var phone: String?
    var imageURL: String?
    var categories: [[String: String]]!
    
    init(data: [String: Any]) {
        
        id = data["id"] as? String ?? "N/A"
        name = data["name"] as? String ?? "N/A"
        rating = data["rating"] as? Float ?? 0.0
        reviewCount = data["review_count"] as? Int ?? 0
        phone = data["phone"] as? String ?? "No number"
        categories = data["categories"] as? [[String: String]] ?? [["alias": "food",
                                                                    "title": "food"]]
        imageURL = data["image_url"] as? String
        
        // Address string
        if let locationInfo = data["location"] as? [String: Any] {
            let city = locationInfo["city"]!
            //let country = locationInfo["country"]
            let state = locationInfo["state"]!
            let address = locationInfo["address1"]!
            
            self.address = "\(String(describing: address))"
            self.city = "\(String(describing: city)), \(String(describing: state))"
        }
        
    }
    
    static func restaurants(dictionaries: [[String: Any]]) -> [Restaurant] {
        var restaurants: [Restaurant] = []
        for dictionary in dictionaries {
            let restaurant = Restaurant(data: dictionary)
            restaurants.append(restaurant)
        }
        
        return restaurants
    }
}
