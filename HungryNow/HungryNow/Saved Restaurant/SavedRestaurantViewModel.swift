//
//  SavedRestaurantViewModel.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/19/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

class SavedRestaurantViewModel: ObservableObject {
    static var savedRestaurantList: [SavedRestaurantViewModel] = []
    static var savedRestaurantIndex: [String] = []
    static var firstTime = true
    
    @Published var restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant

        getDetails()
        
    }
    
    func getDetails() {
        YelpAPI.getDetails(restaurantID: restaurant.id, completion: { (restaurant: Restaurant?, error: Error?) in
            
            if let restaurant = restaurant {
                self.restaurant = restaurant
            }
            
            if let error = error {
                print(error)
            }
        
        })
    }
    
    var id: String {
        return self.restaurant.id
    }
    
    var name: String {
        return self.restaurant.name// ?? savedRestaurant.name
    }
    
    var address: String {
        return self.restaurant.address// ?? savedRestaurant.address
    }

    var city: String {
        return self.restaurant.city// ?? savedRestaurant.city
    }

    var rating: Float {
        return self.restaurant.rating ?? 0
    }

    var reviewCount: Int {
        return self.restaurant.reviewCount ?? 0
    }

    var phone: String {
        return self.restaurant.phone ?? ""//?? savedRestaurant.phone ?? ""
    }

    var price: String {
        return self.restaurant.price ?? ""// ?? savedRestaurant.price ?? ""
    }

    var distance: Float {
        return self.restaurant.distance ?? 0.0
    }

    var imageURL: String {
        return self.restaurant.imageURL ?? ""
    }

    var categories: [[String: String]] {
        return self.restaurant.categories ?? [["title": "Food", "alias": "food"]]
    }

    var restaurantHours: RestaurantHours {
        return self.restaurant.hours ?? RestaurantHours()
    }

}
