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
    
    
    var vcDelegate: UIViewController
    
    @State var isLoading = false
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                NavigationView {
                    VStack (alignment: .leading, spacing: 5) {
                        SearchBar(text: $searchText, onSearchButtonClicked: restaurantListVM.onSearchTapped)
                        
                        List {
                            
                            ForEach(self.restaurantListVM.restaurants, id: \.id) { restaurant in
                                RestaurantRowView(restaurantVM: restaurant, notifications: self.notifications, restaurants: self.restaurants, vcDelegate: self.vcDelegate)
                                    .padding(.bottom, 5)
                                    .listRowBackground(Color("background2"))
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        
                    }
                    .background(Color("background"))
                    .navigationBarTitle(Text("Restaurants"))
                    .navigationBarItems(leading: DismissButton(vcDelegate: vcDelegate))
                }.padding(.top, 20)
            }
            .background(Color("background"))
            .blur(radius: restaurantListVM.isLoading ? 15 : 0)
            if restaurantListVM.isLoading {
                Loading()
            }
        }
        .popup(isPresented: $restaurantListVM.showingErrorPopup, autohideIn: 2) {
            ErrorAlert(error: self.restaurantListVM.error, showingErrorPopup: self.$restaurantListVM.showingErrorPopup)
        }
    }
}

struct RestaurantRowView: View {
    @State var showingAddView = false
    let notifications: Notifications
    var isSaved = false
    let restaurantVM: RestaurantViewModel
    var vcDelegate: UIViewController
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
    
    init(restaurantVM: RestaurantViewModel, notifications: Notifications, restaurants: FetchedResults<SavedRestaurant>, vcDelegate: UIViewController) {
        self.restaurantVM = restaurantVM
        self.vcDelegate = vcDelegate
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
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                HStack (alignment: .top) {
                    imageViewWidget.frame(width: 125, height: 125)
                    VStack (alignment: .leading) {
                        Text(self.restaurantVM.name)
                            .font(.custom("Chivo-Regular", size: 20))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            .foregroundColor(Color("font"))
                            .frame(maxWidth: 220, alignment: .leading)
                        HStack {
                            HStack (alignment: .center, spacing: 5) {
                                Text(String("\(self.restaurantVM.rating)"))
                                    .foregroundColor(Color("font"))
                                    .font(.custom("Chivo-Regular", size: 17))
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.yellow)
                            }
                            Text(String("\(self.restaurantVM.reviewCount) reviews"))
                            Text(self.restaurantVM.price)
                        }
                        Text(self.restaurantVM.address)
                        HStack {
                            Text(self.restaurantVM.city)
                            Text(String(format: "%.2f mi", self.restaurantVM.distance)).frame(width: 100, alignment: .leading)
                        }
                    }
                        
                    
                    Spacer()
                    if (self.isSaved) {
                        Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .foregroundColor(Color("accent2"))
                        .padding(.top, 125 / 2 - 17.5)
                    } else {
                        Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 35, height: 35, alignment: .center)
                        .foregroundColor(Color("accent"))
                        .padding(.top, 125 / 2 - 17.5)
                        .onTapGesture {
                        self.showingAddView = true
                        }
                    }
                }
                
                
                // Nav link
                NavigationLink(destination: SearchAddView(notifications: self.notifications, restaurantVM: self.restaurantVM, vcDelegate: vcDelegate), isActive: self.$showingAddView) {
                    EmptyView()
                }.disabled(self.showingAddView == false)
                
                Text(self.categories)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("background"))
            .foregroundColor(Color("subheading"))
            .font(.custom("Chivo-Regular", size: 15))
        }
        
    }
}
