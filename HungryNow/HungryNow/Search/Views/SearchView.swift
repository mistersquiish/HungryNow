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
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRestaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<SavedRestaurant>
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
                        RestaurantRowView(restaurantVM: restaurant, notifications: self.notifications, restaurants: self.restaurants)
                        
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
    let notifications: Notifications
    var isSaved = false
    let restaurantVM: RestaurantViewModel
    let imageViewWidget: ImageViewWidget
    
    var categories: String {
        get {
            var categories: String = ""
            for category in restaurantVM.categories {
                categories += category["title"]! + ", "
            }
            return String(categories.dropLast().dropLast())
        }
    }
    
    init(restaurantVM: RestaurantViewModel, notifications: Notifications, restaurants: FetchedResults<SavedRestaurant>) {
        self.restaurantVM = restaurantVM
        self.notifications = notifications
        self.imageViewWidget = ImageViewWidget(imageURL: self.restaurantVM.imageURL)
        
        for restaurant in restaurants {
            if restaurantVM.id == restaurant.businessId {
                isSaved = true
                break
            }
        }
    }
    
    var body: some View {
        
        HStack (alignment: .top) {
            imageViewWidget.frame(width: 125, height: 125)
            VStack (alignment: .leading) {
                Text(self.restaurantVM.name).font(.headline)
                HStack {
                    Text(String("\(self.restaurantVM.rating) rating,"))
                    Text(String("\(self.restaurantVM.reviewCount) reviews"))
                    Text(self.restaurantVM.price)
                }
                Text(self.restaurantVM.address)
                Text(self.restaurantVM.city)
                Text(String(format: "%.2f mi", self.restaurantVM.distance)).font(.footnote)
                Text(self.categories).font(.subheadline)
            }
            VStack (alignment: .trailing) {
                NavigationLink(destination: SearchAddView(notifications: self.notifications, restaurantVM: self.restaurantVM), isActive: self.$showingAddView) {
                    EmptyView()
                }.disabled(self.showingAddView == false)
                if (self.isSaved) {
                    Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .accentColor(Color(UIColor.black))
                    .padding(.top, 125 / 2 - 17.5)
                } else {
                    Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .accentColor(Color(UIColor.black))
                    .padding(.top, 125 / 2 - 17.5)
                    .onTapGesture {
                    self.showingAddView = true
                    }
                }

            }.frame(width: 35)

        }
    }
}

struct DismissButton: View {
    let vcDelegate: UIViewController
    
    var body: some View {
        Button( action: {
            self.vcDelegate.dismiss(animated: true)
        }) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .accentColor(Color(UIColor.black))
        }
    }
}
