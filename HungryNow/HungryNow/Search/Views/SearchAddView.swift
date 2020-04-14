//
//  SearchDetailView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

/// View for the search add view of a searched restaurant
struct SearchAddView : View {
    
    //@ObservedObject var restaurantAddVM: RestaurantAddViewModel
    var restaurantVM: RestaurantViewModel
    init(restaurantVM: RestaurantViewModel) {
        self.restaurantVM = restaurantVM
        //self.restaurantAddVM = RestaurantAddViewModel(restaurantVM: restaurantVM)
    }
    
    var body: some View {
        NavigationView {
            Text("hi")
        }
        
    }
}
