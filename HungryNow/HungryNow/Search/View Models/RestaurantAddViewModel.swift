//
//  RestaurantAddViewModel.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

class RestaurantAddViewModel: NSObject, ObservableObject {
    var restaurantVM: RestaurantViewModel
    @Published var hoursVM = HoursViewModel()
        
    init(restaurantVM: RestaurantViewModel) {
        self.restaurantVM = restaurantVM
        super.init()
        
        YelpAPI.getHours(restaurantID: restaurantVM.restaurant.id) { (hours: Hours?, error: Error?) in
            if error != nil {
                print(error!)
            } else if let hours = hours {
                self.hoursVM = HoursViewModel(hours: hours)
            }
        }
    }
}

struct HoursViewModel {
    var days: [Int: [Time]] = [:]
    
    init(hours: Hours) {
        self.days = hours.days
    }
    
    init() {
        self.days = Hours().days
    }
}
