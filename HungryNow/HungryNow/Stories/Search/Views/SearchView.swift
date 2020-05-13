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
    
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                NavigationView {
                    ZStack {
                        // needed to hide the space behind the nav bar
                        Rectangle().fill(Color("background")).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .topLeading)
                        .padding(.top, -200)
                        
                        // Search bar and list of restaurants
                        VStack (alignment: .leading, spacing: 0) {
                            SearchBar(text: $searchText, onSearchButtonClicked: restaurantListVM.onSearchTapped)
                            List {
                                // display output if user query returned 0 results
                                if restaurantListVM.noResults {
                                    NoResultsView(noResultsMessage: NoResultsMessage.Query)
                                }
                                
                                ForEach(self.restaurantListVM.restaurants, id: \.id) { restaurant in
                                    RestaurantRowView(restaurantVM: restaurant, notifications: self.notifications, restaurants: self.restaurants, vcDelegate: self.vcDelegate)
                                        .padding(.bottom, 5)
                                        .listRowBackground(Color("background2"))
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            
                            
                        }
                    }
                    .background(Color("background"))
                    .navigationBarTitle(Text("Restaurants"))
                    .navigationBarItems(leading: DismissButton(vcDelegate: vcDelegate))
                }
                .padding(.top, 20)
            }
            .blur(radius: restaurantListVM.isLoading ? 15 : 0)
            
            if restaurantListVM.isLoading {
                Loading()
            }
        }.background(Color("background"))
            .popup(isPresented: $restaurantListVM.showingErrorPopup, type: .toast, position: .bottom, autohideIn: 2) {
            ErrorAlert(error: self.restaurantListVM.error)
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
            VStack (alignment: .leading, spacing: 10) {
                HStack (alignment: .top) {
                    imageViewWidget.frame(width: 125, height: 125)
                    RestaurantInfoView(restaurantVM: restaurantVM, savedRestaurantVM: nil)
                        
                    
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
                Text(self.categories)
                    .customFont(name: "Chivo-Regular", style: .callout)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("background"))
            .foregroundColor(Color("subheading"))
        }.sheet(isPresented: $showingAddView, onDismiss: { self.showingAddView = false }) {
            SearchAddView(notifications: self.notifications, restaurantVM: self.restaurantVM, vcDelegate: self.vcDelegate)
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
                .accentColor(Color("accent"))
        }
    }
}
