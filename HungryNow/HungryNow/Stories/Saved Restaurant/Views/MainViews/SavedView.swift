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
    
    @State private var hourSelection: Set<String> = []
    @State var didLoadOnce: Bool = false // Used to disable animations during initializatino
        
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ForEach(restaurants, id: \.id) { savedRestaurant in
                    SavedRowView(savedRestaurant: savedRestaurant, notifications: self.notifications, showHours: self.hourSelection.contains(savedRestaurant.businessId!), hourSelection: self.$hourSelection, didLoadOnce: self.$didLoadOnce)
                    .animation(.linear(duration: self.didLoadOnce ? 0.4 : 0))
                    
                }
                .buttonStyle(BorderlessButtonStyle())
                .animation(.linear(duration: self.didLoadOnce ? 0.4 : 0))
                
            }
            .frame(maxWidth: .infinity)
            //.background(Color.yellow)
            .animation(.linear(duration: self.didLoadOnce ? 0.4 : 0))
                
            .navigationBarTitle(Text("Saved Restaurants"))
        }
    
    }
}


struct SavedRowView: View {
    
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    @ObservedObject var notifications: Notifications
    
    @State var showingNotifications = false
    @Binding var didLoadOnce: Bool
    @Binding var hourSelection: Set<String>
    
    let showHours: Bool
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
    
    init(savedRestaurant: SavedRestaurant, notifications: Notifications, showHours: Bool, hourSelection: Binding<Set<String>>, didLoadOnce: Binding<Bool>) {
        self.notifications = notifications
        self.showHours = showHours
        self._hourSelection = hourSelection
        self._didLoadOnce = didLoadOnce
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
                Spacer()
                ActionButton(notifications: notifications, savedRestaurantVM: savedRestaurantVM)
            }
            if showHours {
                HoursView(savedRestaurantVM: savedRestaurantVM)
                    .onTapGesture { self.selectDeselect(self.savedRestaurantVM.id) }
            } else {
                Text("Hours").padding()
                    .onTapGesture {
                        self.didLoadOnce = true
                        self.selectDeselect(self.savedRestaurantVM.id)
                }
            }
            HStack {
                RestaurantButton(buttonType: RestaurantButtonType.Direction, savedRestaurantVM: savedRestaurantVM, showingNotifications: nil)
                RestaurantButton(buttonType: RestaurantButtonType.Phone, savedRestaurantVM: savedRestaurantVM, showingNotifications: nil)
                RestaurantButton(buttonType: RestaurantButtonType.Edit, savedRestaurantVM: nil, showingNotifications: $showingNotifications)
                
            }
            NavigationLink(destination: SavedDetailView(savedRestaurantVM: savedRestaurantVM, notifications: notifications), isActive: self.$showingNotifications) {
                EmptyView()
            }.disabled(self.showingNotifications == false)

            if (nextNotification != nil) {
                Text(nextNotification!).padding(.bottom, 10)
            } else {
                Text("No upcoming notifications").padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 5)
        .background(Color.green)
        
    }
    
    private func selectDeselect(_ restaurantID: String) {
        if hourSelection.contains(restaurantID) {
            hourSelection.remove(restaurantID)
        } else {
            hourSelection.insert(restaurantID)
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



//
//struct ListRowModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        Group {
//            content
//            Divider()
//        }//.offset(x: 20)
//    }
//}
