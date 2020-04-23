//
//  FavoriteView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/18/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import NotificationCenter

struct SavedView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRestaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<SavedRestaurant>
    @ObservedObject var notifications: Notifications
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List(restaurants, id: \.id) { savedRestaurant in
                    SavedRowView(savedRestaurant: savedRestaurant)
                }
                Text(String(notifications.notifications.count))
            }
            .navigationBarTitle(Text("Saved Restaurants"))
        }
        
    }
}


struct SavedRowView: View {
    
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    var categories: String {
        get {
            var categories: String = ""
            for category in savedRestaurantVM.categories {
                categories += category["title"]! + ", "
            }
            return String(categories.dropLast().dropLast())
        }
    }
    
    init(savedRestaurant: SavedRestaurant) {
        let restaurant = Restaurant(savedRestaurant: savedRestaurant)
        savedRestaurantVM = SavedRestaurantViewModel(savedRestaurant: restaurant)
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                ImageViewWidget(imageURL: savedRestaurantVM.imageURL)
                    .frame(width: 125, height: 125)
                VStack (alignment: .leading) {
                    Text(savedRestaurantVM.name).font(.headline)
                    HStack {
                        Text(String("\(savedRestaurantVM.rating) rating,"))
                        Text(String("\(savedRestaurantVM.reviewCount) reviews"))
                        Text(savedRestaurantVM.price)
                    }
                    Text(savedRestaurantVM.address)
                    Text(savedRestaurantVM.city)
                    Text(String(format: "%.2f mi", savedRestaurantVM.distance)).font(.footnote)
                    Text(categories).font(.subheadline)
                }
            }
            HoursView(savedRestaurantVM: savedRestaurantVM)
            
        }
        
    }
}

struct HoursView: View {
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        HStack (alignment: .top) {
            VStack (alignment: .leading) {
                HourView(dayStr: "Sun", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Sunday])
                HourView(dayStr: "Mon", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Monday])
                HourView(dayStr: "Tue", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Tuesday])
                HourView(dayStr: "Wed", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Wednesday])
            }
            VStack (alignment: .leading) {
                HourView(dayStr: "Thu", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Thursday])
                HourView(dayStr: "Fri", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Friday])
                HourView(dayStr: "Sat", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Saturday])
            }
        }
    }
}

struct HourView: View {
    var dayStr: String
    var restaurantTimes: [RestaurantTime]?
    
    var body: some View {
        HStack (alignment: .top) {
            Text(dayStr + ":")
            Text(restaurantTimes?[0].start ?? "N/A")
            Text(restaurantTimes?[0].end ?? "N/A")
        }
    }
}

/// deprecated?
//struct NextNotificationView: View {
//    @ObservedObject var pendingNotifications: WrapperPendingNotifications
//    var nextNotification: String = ""
//
//    init(businessID: String) {
//        pendingNotifications = WrapperPendingNotifications(businessID: businessID)
//    }
//
//    var body: some View {
//        Text(nextNotification)
//    }
//}

//#if DEBUG
//struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedView()
//    }
//}
//#endif
