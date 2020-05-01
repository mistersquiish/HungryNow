//
//  SavedEditView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/23/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct SavedDetailView: View {
    
    @State var showingAdd = false
    
    var savedRestaurantVM: SavedRestaurantViewModel
    @ObservedObject var notifications: Notifications
    var currentNotifications = [UNNotificationRequest]()
    
    init(savedRestaurantVM: SavedRestaurantViewModel, notifications: Notifications) {
        self.savedRestaurantVM = savedRestaurantVM
        self.notifications = notifications
        self.currentNotifications = notifications.getNotifications(restaurantID: savedRestaurantVM.id)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            List {
                ForEach(currentNotifications, id: \.identifier) { notification in
                    SavedDetailRowView(notification: notification)
                }.onDelete(perform: removeRow)
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Button(action : {
            self.showingAdd.toggle()
        }) {
            Image(systemName: "plus")
        }).sheet(isPresented: $showingAdd) {
            SavedDetailAddView(notifications: self.notifications, savedRestaurantVM: self.savedRestaurantVM)
        }
        
    }
    
    func removeRow(at offsets: IndexSet) {
        let indexes = offsets.map({$0})
        let notification = currentNotifications[indexes[0]]
        NotificationManager.removeNotification(identifier: notification.identifier)
        notifications.getCurrentNotifications()
    }
}

struct SavedDetailRowView: View {
    var time: String
    var timeBefore: String
    
    init(notification: UNNotificationRequest) {
        let dateComponents = (notification.trigger as! UNCalendarNotificationTrigger).dateComponents
        let day = Day(rawValue: dateComponents.weekday!)!
        timeBefore = "\(String(describing: day)) - \(notification.content.userInfo["selectedHour"]!)hr \(notification.content.userInfo["selectedMinute"]!)min before closing"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        
        let timeNoFormat = DateComponents(hour: dateComponents.hour, minute: dateComponents.minute)
        
        time = dateFormatter.string(from: NSCalendar.current.date(from: timeNoFormat)!)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(time).font(.largeTitle)
            Text(timeBefore)
        }
        
    }
}
