//
//  SearchView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import CoreLocation
import SwiftUI

/// View for the search to add restaurant feature
struct SearchView : View {
    
    @ObservedObject var restaurantListVM = RestaurantListViewModel()
    @State private var searchText: String = ""
    
    var vcDelegate: UIViewController

    var body: some View {
        VStack (alignment: .leading) {
            DismissButton(vcDelegate: vcDelegate)
            SearchBar(text: $searchText, onSearchButtonClicked: restaurantListVM.onSearchTapped)
            List(self.restaurantListVM.restaurants, id: \.id) { restaurant in
                RestaurantRowView(restaurant: restaurant)
            }
        }
        
    }
}

struct RestaurantRowView: View {
    let restaurant: RestaurantViewModel
    
    var body: some View {
        HStack (alignment: .top) {
            ImageViewWidget(imageURL: restaurant.imageURL)
            .frame(width: 125, height: 125)
            VStack (alignment: .leading) {
                Text(restaurant.name).font(.title)
                HStack {
                    Text(String("\(restaurant.rating) rating,"))
                    Text(String("\(restaurant.reviewCount) reviews"))
                }
                Text(restaurant.address)
                Text(restaurant.city)
            }
        }
    }
}

struct DismissButton: View {
    let vcDelegate: UIViewController
    
    var body: some View {
        Button( action: {
            self.vcDelegate.dismiss(animated: true)
        }) {
            Image("exit-button")
                .resizable()
                .frame(width: 25, height: 25)
                .accentColor(Color(UIColor.black))
        }
        .padding(.top, 50)
        .padding(.leading)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(vcDelegate: UIViewController.init())
    }
}
