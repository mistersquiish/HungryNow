//
//  RestaurantAnnotation.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/10/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let restaurant: Restaurant

    init(title: String, restaurant: Restaurant, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.restaurant = restaurant
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return nil
    }
}
