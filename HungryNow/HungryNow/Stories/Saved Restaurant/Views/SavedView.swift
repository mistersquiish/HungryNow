//
//  FavoriteView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/18/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import NotificationCenter
import CoreLocation

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
                    }
                    .onDelete(perform: removeRow)
                    .buttonStyle(BorderlessButtonStyle())
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
    
    @State var showingNotifications = false
    
    var nextNotification: String?
    let imageViewWidget: ImageViewWidget
    
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
        let savedRestaurantVM = SavedRestaurantViewModel(restaurant: restaurant)
        self.savedRestaurantVM = savedRestaurantVM
        self.imageViewWidget = ImageViewWidget(imageURL: savedRestaurantVM.imageURL)
        
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
        VStack (alignment: .leading) {
            HStack (alignment: .top) {
                imageViewWidget.frame(width: 125, height: 125)
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
            HStack {
                DirectionsButton(savedRestaurantVM: savedRestaurantVM)
                PhoneButton(savedRestaurantVM: savedRestaurantVM)
                EditButton(showingNotifications: $showingNotifications)
            }
            NavigationLink(destination: SavedDetailView(savedRestaurantVM: savedRestaurantVM, notifications: notifications), isActive: self.$showingNotifications) {
                EmptyView()
            }.disabled(self.showingNotifications == false)
            
            if (nextNotification != nil) {
                Text(nextNotification!)
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


struct DirectionsButton: View {
    var savedRestaurantVM: SavedRestaurantViewModel
    var query: String
    
    init(savedRestaurantVM: SavedRestaurantViewModel) {
        self.savedRestaurantVM = savedRestaurantVM
        
        var query = savedRestaurantVM.name + " " + savedRestaurantVM.address + " " + savedRestaurantVM.city
        query = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        self.query = query
    }
    
    var body: some View {
        Button(action: {
            // Try GoogleMaps first
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(self.query)")!, options: [:], completionHandler: nil)
            }
            // Try AppleMaps
            else if  UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com/")!) {
                UIApplication.shared.open(URL(string:"http://maps.apple.com/?address=\(self.query)")!, options: [:], completionHandler: nil)
            }
            // Open Google Maps on browser
            else {
                UIApplication.shared.open(URL(string: "http://maps.google.com/maps?daddr=\(self.query)")!, options: [:], completionHandler: nil)
            }
        }) {
            Text("Directions").foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(30.0)
        }
    }
}

struct PhoneButton: View {
    var savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel://\(self.savedRestaurantVM.phone)") {
               UIApplication.shared.open(url)
             }
        }) {
            Text("Call").foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(30.0)
        }
    }
}

struct EditButton: View {
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: {
            self.showingNotifications.toggle()
        }) {
            Text("Edit").foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(30.0)
        }
    }
}
