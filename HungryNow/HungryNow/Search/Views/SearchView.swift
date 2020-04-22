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
    @ObservedObject var notifications: Notifications
    @State private var searchText: String = ""
    
    var vcDelegate: UIViewController

    var body: some View {
        VStack (alignment: .leading) {
            NavigationView {
                VStack (alignment: .leading) {
                    SearchBar(text: $searchText, onSearchButtonClicked: restaurantListVM.onSearchTapped)
                    
                    List(self.restaurantListVM.restaurants, id: \.id) { restaurant in
                        NavigationLink(destination: SearchAddView(notifications: self.notifications, restaurantVM: restaurant)) {

                            RestaurantRowView(restaurant: restaurant)
                        }
                        
                    }
                }
                .navigationBarTitle(Text("Restaurants"))
                .navigationBarItems(leading: DismissButton(vcDelegate: vcDelegate))
            }
            .padding(.top, 25)
        }
    }
}

struct RestaurantRowView: View {
    @State var showingAddView = false
    let restaurant: RestaurantViewModel
    var categories: String {
        get {
            var categories: String = ""
            for category in restaurant.categories {
                categories += category["title"]! + ", "
            }
            return String(categories.dropLast().dropLast())
        }
    }
    
    var body: some View {
        HStack (alignment: .top) {
            ImageViewWidget(imageURL: restaurant.imageURL)
                .frame(width: 125, height: 125)
            VStack (alignment: .leading) {
                Text(restaurant.name).font(.headline)
                HStack {
                    Text(String("\(restaurant.rating) rating,"))
                    Text(String("\(restaurant.reviewCount) reviews"))
                    Text(restaurant.price)
                }
                Text(restaurant.address)
                Text(restaurant.city)
                Text(String(format: "%.2f mi", restaurant.distance)).font(.footnote)
                Text(categories).font(.subheadline)
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
    }
}
