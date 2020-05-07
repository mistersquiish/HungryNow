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
        
        UITableView.appearance().backgroundColor = UIColor(named: "background2")
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        List {
            Section(header: NotificationHeader(savedRestaurantVM: savedRestaurantVM)) {
                ForEach(currentNotifications, id: \.identifier) { notification in
                    SavedDetailRowView(notification: notification)
                        .padding(.bottom, 1)
                    .listRowBackground(Color("background2"))
                }.onDelete(perform: removeRow)
                
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .background(Color("background2"))
        }
        
        
        .navigationBarTitle(Text(""))
        .navigationBarItems(trailing:
        Button(action: {
            self.showingAdd.toggle()
        }) {
            ZStack (alignment: .trailing) {
                Rectangle().fill(Color.clear).frame(width: 60, height: 40)
                Image(systemName: "plus")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
                .foregroundColor(Color("accent"))
            }
            
        }).sheet(isPresented: $showingAdd, onDismiss: { self.showingAdd = false }) {
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
        Group {
            VStack (alignment: .leading, spacing: 10) {
                Text(time).font(.largeTitle)
                    .font(.custom("Chivo-Regular", size: 45))
                    .foregroundColor(Color("font"))
                Text(timeBefore)
                    .font(.custom("Chivo-Regular", size: 15))
                    .foregroundColor(Color("subheading"))
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .padding(.top, 25)
        .padding(.bottom, 25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("background"))
        
        
    }
}

struct NotificationHeader: View {
    let savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(savedRestaurantVM.name)
                .font(.custom("Chivo-Regular", size: 30))
                .foregroundColor(Color("font"))
            Text(savedRestaurantVM.address)
                .padding(.leading, 1)
                .font(.custom("Chivo-Regular", size: 15))
                .foregroundColor(Color("subheading"))
        }
        .padding(.top, 30)
        .padding(.leading, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("background2"))
    }
}
