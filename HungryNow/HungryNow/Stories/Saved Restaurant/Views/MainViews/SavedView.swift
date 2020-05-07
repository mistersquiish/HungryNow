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
    @State var didLoadOnce: Bool = false // Used to disable animations during initialization
    
    init(notifications: Notifications) {
        self.notifications = notifications
        
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(named: "accent")!,
            .font: UIFont(name:"Chivo-Regular", size: 25)!
        ]
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "accent")!,
            .font: UIFont(name:"Chivo-Regular", size: 30)!
        ]
        
    }
        
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Saved Restaurants").font(.custom("Chivo-Regular", size: 30))
                        .foregroundColor(Color("font"))
                        .frame(alignment: .leading)
                        .padding(.leading, 15)
                    Spacer()
                }.padding(.top, 15)
                ZStack {
                    Color("background2")
                    VStack (spacing: 30) {
                        ForEach(restaurants, id: \.id) { savedRestaurant in
                            SavedRowView(savedRestaurant: savedRestaurant, notifications: self.notifications, showHours: self.hourSelection.contains(savedRestaurant.businessId!), hourSelection: self.$hourSelection, didLoadOnce: self.$didLoadOnce)
                            .animation(.linear(duration: self.didLoadOnce ? 0.3 : 0))
                            
                        }
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .background(Color("background2"))
            
            .navigationBarTitle("HungryNow", displayMode: .inline)
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
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            // Restaurant info View
            HStack (alignment: .top) {
                imageViewWidget.frame(width: 125, height: 125)
                VStack (alignment: .leading, spacing: 0) {
                    Text(savedRestaurantVM.name)
                        .foregroundColor(Color("font"))
                        .font(.custom("Chivo-Regular", size: 20))
                    HStack {
                        HStack (alignment: .center, spacing: 5) {
                            Text(String("\(savedRestaurantVM.rating)"))
                                .foregroundColor(Color("font"))
                                .font(.custom("Chivo-Regular", size: 17))
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color.yellow)
                        }
                        Text(String("\(savedRestaurantVM.reviewCount) reviews"))
                        Text(savedRestaurantVM.price)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    Text(savedRestaurantVM.address)
                    
                    HStack {
                        Text(savedRestaurantVM.city)
                        Text(String(format: "%.2f mi", savedRestaurantVM.distance)).frame(width: 100, alignment: .leading)
                    }
                    
                }
                    .foregroundColor(Color("subheading"))
                    .font(.custom("Chivo-Regular", size: 15))
                Spacer()
                ActionButton(notifications: notifications, savedRestaurantVM: savedRestaurantVM)
            }
            
            // Hours View
            if showHours {
                VStack (alignment: .leading) {
                    HStack (spacing: 5) {
                        if savedRestaurantVM.isOpen {
                            Text("Open").foregroundColor(Color.green)
                        } else {
                            Text("Closed").foregroundColor(Color.red)
                        }
                        Text("") // blank text for consistent spacing
                        Image(systemName: "chevron.up").foregroundColor(Color("font"))
                    }
                    HoursView(savedRestaurantVM: savedRestaurantVM)
                        .onTapGesture { self.selectDeselect(self.savedRestaurantVM.id) }
                }.padding()
            } else {
                Group {
                    HStack (spacing: 5) {
                        if savedRestaurantVM.isOpen {
                            Text("Open").foregroundColor(Color.green)
                            Text("•").font(.custom("Chivo-Regular", size: 8)).foregroundColor(Color("subheading"))
                        } else {
                            Text("Closed").foregroundColor(Color.red)
                        }
                        Text(savedRestaurantVM.nextClosingTime).foregroundColor(Color("subheading"))
                        Image(systemName: "chevron.down").foregroundColor(Color("font"))
                    }
                }
                    .padding()
                    .onTapGesture {
                        self.didLoadOnce = true
                        self.selectDeselect(self.savedRestaurantVM.id)
                    }
            }
            Divider()
            
            // Restaurant buttons View
            HStack (spacing: 0) {
                RestaurantButton(buttonType: RestaurantButtonType.Direction, savedRestaurantVM: self.savedRestaurantVM, showingNotifications: nil)
                Divider().frame(height: 30)
                RestaurantButton(buttonType: RestaurantButtonType.Phone, savedRestaurantVM: self.savedRestaurantVM, showingNotifications: nil)
                Divider().frame(height: 30)
                RestaurantButton(buttonType: RestaurantButtonType.Edit, savedRestaurantVM: nil, showingNotifications: self.$showingNotifications)
            }
            
            // Hidden Nav link
            NavigationLink(destination: SavedDetailView(savedRestaurantVM: savedRestaurantVM, notifications: notifications), isActive: self.$showingNotifications) {
                EmptyView()
            }.disabled(self.showingNotifications == false)

            NextNotificaionsView(notifications: notifications, restaurantID: savedRestaurantVM.id)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Rectangle().fill(Color("background")).shadow(radius: 8))
        
        
        
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
        VStack (alignment: .leading) {
            HourView(dayStr: "Sun", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Sunday])
            HourView(dayStr: "Mon", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Monday])
            HourView(dayStr: "Tue", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Tuesday])
            HourView(dayStr: "Wed", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Wednesday])
            HourView(dayStr: "Thu", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Thursday])
            HourView(dayStr: "Fri", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Friday])
            HourView(dayStr: "Sat", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Saturday])
        }
    }
}

struct HourView: View {
    var dayStr: String
    var restaurantTimes = [RestaurantTime]()
    
    init(dayStr: String, restaurantTimes: [RestaurantTime]?) {
        self.dayStr = dayStr
        if restaurantTimes != nil {
            self.restaurantTimes = restaurantTimes!
        }
    }
    
    var body: some View {
        HStack (alignment: .top) {
            Text(dayStr + ":").frame(width: 40, alignment: .trailing)
            if restaurantTimes.isEmpty {
                Text("Closed")
            } else {
                VStack {
                    ForEach(restaurantTimes) { restaurantTime in
                        HourSlotView(restaurantTime: restaurantTime)
                    }
                }
            }
        }
        .font(.custom("Chivo-Regular", size: 15))
        .foregroundColor(Color("subheading"))
    }
}

struct HourSlotView: View {
    var start: String
    var end: String
    
    init(restaurantTime: RestaurantTime) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        let start = DateComponents(hour: Int(restaurantTime.start.prefix(2)), minute: Int(restaurantTime.start.suffix(2)))
        let end =  DateComponents(hour: Int(restaurantTime.end.prefix(2)), minute: Int(restaurantTime.end.suffix(2)))
        
        self.start = dateFormatter.string(from: NSCalendar.current.date(from: start)!)
        self.end = dateFormatter.string(from: NSCalendar.current.date(from: end)!)
    }
    
    var body: some View {
        HStack {
            Text(start)
            Text("—")
            Text(end)
        }
    }
}

struct NextNotificaionsView: View {
    var nextNotification: String = "No notification set"
    
    init(notifications: Notifications, restaurantID: String) {
        // create next notification string
        if let nextNotification = notifications.getNextNotification(restaurantID: restaurantID) {
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
        Text(nextNotification)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(Color("font"))
            .font(.custom("Chivo-Regular", size: 15))
            .background(Color("background3"))
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
