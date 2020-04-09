//
//  File.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

class Restaurant {
    var placeID: String!
    var name: String!
    var address: String!
    var rating: Float!
    
    init(data: [String: Any]) {
        do {
            let types: [String] = data["types"] as! [String]
            
            // if data passed in is not a restaurant
            if !types.contains("restaurant") {
                throw GoogleAPIError.NotRestaurant
            }
        } catch GoogleAPIError.NotRestaurant {
            print(GoogleAPIError.NotRestaurant.localizedDescription)
        } catch {
            print(error)
        }
        
        placeID = data["place_id"] as? String ?? "N/A"
        name = data["name"] as? String ?? "N/A"
        address = data["formatted_address"] as? String ?? "N/A"
        rating = data["rating"] as? Float ?? 0.0
    }
}
