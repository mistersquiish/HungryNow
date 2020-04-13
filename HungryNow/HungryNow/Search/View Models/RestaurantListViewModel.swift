//
//  RestaurantListViewModel.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Alamofire
import AlamofireImage
import SwiftUI

class RestaurantListViewModel: NSObject, ObservableObject {
    @Published var restaurants = [RestaurantViewModel]()
    
    var locationManager = LocationManager()
    
    override init() {
        super.init()        
    }
    
    func onSearchTapped(query: String) {
        if let location = locationManager.getCurrentLocation() {
            YelpAPI.getSearch(query: query, cllocation: location ) { (restaurants: [Restaurant]?, error: Error?) in
                if error != nil {
                    print(error!)
                } else if let restaurants = restaurants {
                    self.restaurants = restaurants.map(RestaurantViewModel.init)
                    
                }
            }
        } else {
            print("no location enabled")
        }
    }
}

struct RestaurantViewModel {
    var restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    var id: String {
        return self.restaurant.id
    }
    
    var name: String {
        return self.restaurant.name
    }
    
    var address: String {
        return self.restaurant.address
    }
    
    var city: String {
        return self.restaurant.city
    }
    
    var rating: Float {
        return self.restaurant.rating
    }
    
    var reviewCount: Int {
        return self.restaurant.reviewCount
    }
    
    var phone: String {
        return self.restaurant.phone ?? "No phone"
    }
    
    var price: String {
        return self.restaurant.price ?? "$"
    }
    
    var distance: Float {
        return self.restaurant.distance
    }
    
    var imageURL: String {
        return self.restaurant.imageURL ?? ""
    }
    
    var categories: [[String: String]] {
        return self.restaurant.categories
    }
    
}
