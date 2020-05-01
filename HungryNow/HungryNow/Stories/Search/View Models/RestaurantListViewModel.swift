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
    @Published var error: Error?
    @Published var showingErrorPopup = false
    @Published var isLoading = false
    
    var locationManager = LocationManager()
    
    override init() {
        super.init()
    }
    
    func onSearchTapped(query: String) {
        self.isLoading = true
        if let location = locationManager.getCurrentLocation() {
            YelpAPI.getSearch(query: query, cllocation: location) { (restaurants: [Restaurant]?, error: Error?) in
                if error != nil {
                    self.error = error
                    self.showingErrorPopup = true
                    self.isLoading = false
                    return
                } else if let restaurants = restaurants {
                    // no restaurants found
                    if restaurants.count == 0 {
                        self.error = SearchError.NoBusinesses
                        self.showingErrorPopup = true
                    }
                    
                    self.restaurants = restaurants.map(RestaurantViewModel.init)
                    self.isLoading = false
                }
            }
        } else {
            print("no location enabled")
            self.error = NotificationError.LocationNotEnabled
            self.showingErrorPopup = true
            self.isLoading = false
            return
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
        return self.restaurant.rating ?? 0
    }
    
    var reviewCount: Int {
        return self.restaurant.reviewCount ?? 0
    }
    
    var phone: String {
        return self.restaurant.phone ?? "No phone"
    }
    
    var price: String {
        return self.restaurant.price ?? "$"
    }
    
    var distance: Float {
        return self.restaurant.distance ?? 0.0
    }
    
    var imageURL: String {
        return self.restaurant.imageURL ?? ""
    }
    
    var categories: [[String: String]] {
        return self.restaurant.categories
    }
    
}
