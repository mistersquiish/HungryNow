//
//  SearchView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SearchView : View {
    
    @ObservedObject var restaurantListVM = RestaurantListViewModel()
    @State private var searchText: String = ""

    var body: some View {
        
        VStack {
            SearchBar(text: $searchText, onSearchButtonClicked: restaurantListVM.onSearchTapped)
            List(self.restaurantListVM.restaurants, id: \.id) { restaurant in
                VStack {
                    Text(restaurant.name)
                    Text(restaurant.address)
                }
                
            }
        }.padding()
    }
    
   
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
