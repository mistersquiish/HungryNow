//
//  SavedRestaurantViewModel.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/19/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation

class SavedRestaurantViewModel: ObservableObject {
    // static vars for updating core data of restaurants if information has changed on Yelp
    static var updated: [String: Bool] = [:]
    static var savedRestaurantList: [SavedRestaurantViewModel] = []
    static var savedRestaurantIndex: [String] = []
    static var firstTime = true
    
    @Published var restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        // code to fetch for updates from Yelp and add restaurant to update queue if information has changed
        if SavedRestaurantViewModel.savedRestaurantIndex.firstIndex(of: restaurant.id) == nil {
            SavedRestaurantViewModel.savedRestaurantList.append(self)
            SavedRestaurantViewModel.savedRestaurantIndex.append(restaurant.id)
        }
        if SavedRestaurantViewModel.firstTime {
            // Update the saved restaurants once by making API call in background
            if SavedRestaurantViewModel.updated[restaurant.id] == nil {
                DispatchQueue.global(qos: .background).async {
                    self.updateDetailsInBackground()
                }
                SavedRestaurantViewModel.updated[restaurant.id] = true
            }
            SavedRestaurantViewModel.firstTime = false
        }
        
        
    }
    
    func updateDetailsInBackground() {
        
        YelpAPI.getDetails(restaurantID: self.restaurant.id, completion: { (restaurant: Restaurant?, error: Error?) in
            
            // code to run next restaurant request
            let index = SavedRestaurantViewModel.savedRestaurantIndex.firstIndex(of: self.restaurant.id)! + 1
            if index < SavedRestaurantViewModel.savedRestaurantIndex.count {
                SavedRestaurantViewModel.savedRestaurantList[index].updateDetailsInBackground()
            }
            if let restaurant = restaurant {
                // Update core data if necessary
                CoreDataManager.addRestaurantToUpdate(savedRestaurant: self.restaurant, updatedRestaurant: restaurant)
            }
            
            if let error = error {
                print("Error report")
                print(error)
                print(error.self)
                print(error.localizedDescription)
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
