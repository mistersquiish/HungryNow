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
                List {
                    ForEach(restaurants, id: \.id) { savedRestaurant in
                        SavedRowView(savedRestaurant: savedRestaurant, notifications: self.notifications)
                    }.onDelete(perform: removeRow)
                }
                
            }
            .navigationBarTitle(Text("Saved Restaurants"))
        }
        
    }
    
    func removeRow(at offsets: IndexSet) {
        let indexes = offsets.map({$0})
        let savedRestaurant = restaurants[indexes[0]]
        
        // clear notification
        notifications.removeNotifications(restaurantID: savedRestaurant.businessId!)
        
        // clear core data
        CoreDataManager.deleteRestaurant(savedRestaurant: savedRestaurant)
    }
}


struct SavedRowView: View {
    
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    @ObservedObject var notifications: Notifications
    var nextNotification: String?
    
    var categories: String {
        get {
            var categories: String = ""
            for category in savedRestaurantVM.categories {
                categories += category["title"]! + ", "
            }
            return String(categories.dropLast().dropLast())
        }
    }
    
    init(savedRestaurant: SavedRestaurant, notifications: Notifications) {
        self.notifications = notifications
        let restaurant = Restaurant(savedRestaurant: savedRestaurant)
        savedRestaurantVM = SavedRestaurantViewModel(restaurant: restaurant)
        // create next notification string
        if let nextNotification = notifications.getNextNotification(restaurantID: restaurant.id) {
            let dateComponents = (nextNotification.trigger as! UNCalendarNotificationTrigger).dateComponents
            let day = Day(rawValue: dateComponents.weekday!)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mma"
            
            let timeNoFormat = DateComponents(hour: dateComponents.hour, minute: dateComponents.minute)
            
            let time = dateFormatter.string(from: NSCalendar.current.date(from: timeNoFormat)!)
            
            self.nextNotification = "Next notification on \(String(describing: day)) at \(time)"
        }
    }
    
    var body: some View {
        NavigationLink(destination: SavedDetailView(savedRestaurantVM: savedRestaurantVM, notifications: notifications)) {
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
                if (nextNotification != nil) {
                    Text(nextNotification!)
                }
            }
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


//#if DEBUG
//struct FavoriteView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedView()
//    }
//}
//#endif
