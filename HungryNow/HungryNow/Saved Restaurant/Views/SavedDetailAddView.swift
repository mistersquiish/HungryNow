//
//  SavedDetailAddView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/25/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

/// View for the notification add view of a saved restaurant
struct SavedDetailAddView : View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @ObservedObject var notifications: Notifications
        
    var savedRestaurantVM: SavedRestaurantViewModel
    @State private var selectedTime = DurationPickerTime(hour: 1, minute: 0)
    private var selectedDays: [Day] {
        get {
            var days: [Day] = []
            if moToggled {
                days.append(Day.Monday)
            }
            if tuToggled {
                days.append(Day.Tuesday)
            }
            if weToggled {
                days.append(Day.Wednesday)
            }
            if thToggled {
                days.append(Day.Thursday)
            }
            if frToggled {
                days.append(Day.Friday)
            }
            if saToggled {
                days.append(Day.Saturday)
            }
            if suToggled {
                days.append(Day.Sunday)
            }
            return days
        }
    }
    
    // Day Button toggles
    @State private var moToggled: Bool = false
    @State private var tuToggled: Bool = false
    @State private var weToggled: Bool = false
    @State private var thToggled: Bool = false
    @State private var frToggled: Bool = false
    @State private var saToggled: Bool = false
    @State private var suToggled: Bool = false
    
    var body: some View {
        ZStack {
            Button (action: {
                self.mode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .accentColor(Color(UIColor.black))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading)
            .padding(.top, 25)
            .padding(.leading, 25)
            
            HStack (alignment: .top) {

                VStack (alignment: .center) {
                    Text("When would you like to be notified?")
                        .frame(maxHeight: 100)
                        .multilineTextAlignment(.center)
                        .font(.title)
                    DurationPickerView(time: $selectedTime)

                    Text("What days do you want to be notified")
                    HStack {
                        DayButton(day: "Su", toggled: $suToggled)
                        DayButton(day: "Mo", toggled: $moToggled)
                        DayButton(day: "Tu", toggled: $tuToggled)
                        DayButton(day: "We", toggled: $weToggled)
                        DayButton(day: "Th", toggled: $thToggled)
                        DayButton(day: "Fr", toggled: $frToggled)
                        DayButton(day: "Sa", toggled: $saToggled)
                    }

                    AddButton(notifications: notifications, savedRestaurantVM: savedRestaurantVM, selectedDays: selectedDays, selectedTime: $selectedTime)
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
            })
        }
        
        
    }
        
}

struct AddButton: View {
    
    var notifications: Notifications
    
    var savedRestaurantVM: SavedRestaurantViewModel
    var selectedDays: [Day]
    @Binding var selectedTime: DurationPickerTime
    
    var body: some View {
        Button( action: {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if let error = error {
                    print(error)
                    // Handle the error here.
                }
                
                if granted {
                    HungryNowManager.addNotification(restaurant: self.savedRestaurantVM.restaurant, selectedDays: self.selectedDays, selectedTime: self.selectedTime, hours: self.savedRestaurantVM.restaurantHours) { (success: Bool, error: Error?) in
                        if success {
                            self.notifications.getCurrentNotifications()
                        } else if let error = error {
                            print(error)
                        }
                    }
                }
            }
        }) {
            HStack {
                Text("Add")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
        }.padding()
    }
}
