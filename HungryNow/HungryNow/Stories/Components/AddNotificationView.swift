//
//  AddNotificationView.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/7/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

enum ConfirmNewNotification {
    case Add
    case Save
}

struct AddNotificationView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var confirmNewNotification: ConfirmNewNotification
    @ObservedObject var notifications: Notifications
    var restaurant: Restaurant
    
    // Binding variables for popups
    @Binding var showingErrorPopup: Bool
    @Binding var showingSuccessPopup: Bool
    @Binding var error: Error?
    
    // Day Button toggles
    @State private var moToggled: Bool = false
    @State private var tuToggled: Bool = false
    @State private var weToggled: Bool = false
    @State private var thToggled: Bool = false
    @State private var frToggled: Bool = false
    @State private var saToggled: Bool = false
    @State private var suToggled: Bool = false
    
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
    
    var body: some View {
        VStack (alignment: .center, spacing: 15) {
            VStack (alignment: .center) {
                Text("When would you like to be")
                    .font(.custom("Chivo-Regular", size: 30))
                Text("notified?")
                    .font(.custom("Chivo-Regular", size: 30))
            }
                .font(.title)
                
            DurationPickerView(time: $selectedTime)

            Text("What days do you want to be notified")
                .font(.custom("Chivo-Regular", size: 15))
            HStack {
                Spacer()
                DayButton(day: "Su", toggled: $suToggled)
                DayButton(day: "Mo", toggled: $moToggled)
                DayButton(day: "Tu", toggled: $tuToggled)
                DayButton(day: "We", toggled: $weToggled)
                DayButton(day: "Th", toggled: $thToggled)
                DayButton(day: "Fr", toggled: $frToggled)
                DayButton(day: "Sa", toggled: $saToggled)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 10)

            if confirmNewNotification == ConfirmNewNotification.Add {
                AddButton(notifications: notifications, restaurant: restaurant, selectedDays: selectedDays, showingSuccessPopup: $showingSuccessPopup, showingErrorPopup: $showingErrorPopup, error: $error, selectedTime: $selectedTime)
            } else {
                SaveButton(showingSuccessPopup: $showingSuccessPopup, showingErrorPopup: $showingErrorPopup, error: $error, notifications: notifications, restaurant: restaurant, selectedDays: selectedDays, selectedTime: $selectedTime)
            }
            Spacer()
        }.padding(.top, 10)
    }
}

struct AddButton: View {
    
    var notifications: Notifications
    
    var restaurant: Restaurant
    var selectedDays: [Day]
    
    @Binding var showingSuccessPopup: Bool
    @Binding var showingErrorPopup: Bool
    @Binding var error: Error?
    @Binding var selectedTime: DurationPickerTime
    
    var body: some View {
        Button( action: {
            HungryNowManager.addNotification(restaurant: self.restaurant, selectedDays: self.selectedDays, selectedTime: self.selectedTime, hours: self.restaurant.hours!) { (success: Bool, error: Error?) in
                if success {
                    self.showingSuccessPopup = true
                    self.notifications.getCurrentNotifications()
                } else if let error = error {
                    self.error = error
                    self.showingErrorPopup = true
                }
            }
        }) {
            AccentButton(buttonLabel: "Add")
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct SaveButton: View {
    
    @Binding var showingSuccessPopup: Bool
    @Binding var showingErrorPopup: Bool
    @Binding var error: Error?
    
    var notifications: Notifications
    
    var restaurant: Restaurant
    var selectedDays: [Day]
    @Binding var selectedTime: DurationPickerTime
    
    var body: some View {
        Button( action: {
            HungryNowManager.addNewRestaurant(restaurant: self.restaurant, selectedDays: self.selectedDays, selectedTime: self.selectedTime) { (success: Bool, error: Error?) in
                if success {
                    self.showingSuccessPopup = true
                    self.notifications.getCurrentNotifications()
                } else if let error = error {
                    // Notification and YelpAPI Errors
                    self.error = error
                    self.showingErrorPopup = true
                    self.showingSuccessPopup = false
                }
            }
        }) {
            AccentButton(buttonLabel: "Save")
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct AccentButton: View {
    var buttonLabel: String
    
    var body: some View {
        HStack {
            Text(buttonLabel)
                .fontWeight(.semibold)
                .font(.custom("Chivo-Regular", size: 30))
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(Color("background"))
        .background(Color("accent"))
        .cornerRadius(40)
    }
}
