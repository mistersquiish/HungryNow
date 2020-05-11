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
    @Published var restaurants = [RestaurantViewModel]() {
        didSet {
            updateCount += 1
        }
    }
    @Published var error: Error?
    @Published var showingErrorPopup = false
    @Published var isLoading = false
    @Published var noResults = false
    
    var updateCount = 0 // Used to let the mapview know when it needs to update the annotations
    var locationManager = LocationManager()
    
    override init() {
        super.init()
    }
    
    func onSearchTapped(query: String?, limit: Int, locationQuery: CLLocationCoordinate2D?) {
        self.isLoading = true
        self.noResults = false
        
        var coordinate: CLLocationCoordinate2D?
        if let locationQuery = locationQuery {
            coordinate = locationQuery
        } else if let currentLocation = locationManager.getCurrentLocation() {
            coordinate = currentLocation.coordinate
        }
        
        
        if let coordinate = coordinate {
            YelpAPI.getSearch(query: query, coordinate: coordinate, limit: limit) { (restaurants: [Restaurant]?, error: Error?) in
                if error != nil {
                    self.error = error
                    self.showingErrorPopup = true
                    self.isLoading = false
                    return
                } else if let restaurants = restaurants {
                    // no restaurants found. inform the parent to display a no results output
                    if restaurants.count == 0 {
                        self.noResults = true
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
    var restaurant: Restaurant?
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    init() {}
    
    var id: String {
        return self.restaurant?.id ?? "id"
    }
    
    var name: String {
        return self.restaurant?.name ?? "Name"
    }
    
    var address: String {
        return self.restaurant?.address ?? "Address"
    }
    
    var city: String {
        return self.restaurant?.city ?? "City, State"
    }
    
    var rating: Float {
        return self.restaurant?.rating ?? 0
    }
    
    var reviewCount: Int {
        return self.restaurant?.reviewCount ?? 0
    }
    
    var phone: String {
        return self.restaurant?.phone ?? "No phone"
    }
    
    var price: String {
        return self.restaurant?.price ?? "$"
    }
    
    var distance: Float {
        return self.restaurant?.distance ?? 0.0
    }
    
    var imageURL: String {
        return self.restaurant?.imageURL ?? ""
    }
    
    var categories: [[String: String]] {
        return self.restaurant?.categories ?? [["title": "title"]]
    }
    
}
