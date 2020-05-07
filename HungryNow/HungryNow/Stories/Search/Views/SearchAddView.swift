//
//  SearchDetailView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI
import ExytePopupView

/// View for the search add view of a searched restaurant
struct SearchAddView : View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var notifications: Notifications
    
    // State variables for popups
    @State var showingErrorPopup = false
    @State var showingSuccessPopup = false
    @State var error: Error?
        
    var restaurantVM: RestaurantViewModel
    var vcDelegate: UIViewController
    
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
        // Popup Views
        ZStack {
            VStack (alignment: .center, spacing: 15) {
                Text("When would you like to be notified?")
                    .padding(.top, 100)
                    .frame(maxHeight: 200)
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
                .padding(.top, 15)
                .padding(.bottom, 15)
                
                SaveButton(showingSuccessPopup: $showingSuccessPopup, showingErrorPopup: $showingErrorPopup, error: $error, notifications: notifications, restaurantVM: restaurantVM, selectedDays: selectedDays, selectedTime: $selectedTime)
                
                Spacer()
            }
        }
        .foregroundColor(Color("font"))
        .background(Color("background"))
        
        .popup(isPresented: $showingErrorPopup, autohideIn: 2) {
            ErrorAlert(error: self.error, showingErrorPopup: self.$showingErrorPopup)
        }
            
        .popup(isPresented: $showingSuccessPopup, autohideIn: 2) {
            SuccessAlert(showingSuccessPopup: self.$showingSuccessPopup, vcDelegate: self.vcDelegate)
        }
        
        
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            ZStack (alignment: .leading) {
                Rectangle().fill(Color.clear)
                    .frame(width: 40, height: 40)
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("accent"))
            }
        })
        
        
        
        
    }
        
}

struct SaveButton: View {
    
    @Binding var showingSuccessPopup: Bool
    @Binding var showingErrorPopup: Bool
    @Binding var error: Error?
    
    var notifications: Notifications
    
    var restaurantVM: RestaurantViewModel
    var selectedDays: [Day]
    @Binding var selectedTime: DurationPickerTime
    
    var body: some View {
        Button( action: {
            HungryNowManager.addNewRestaurant(restaurant: self.restaurantVM.restaurant, selectedDays: self.selectedDays, selectedTime: self.selectedTime) { (success: Bool, error: Error?) in
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
            HStack {
                Text("Save")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color("accent"))
            .cornerRadius(40)
        }.padding()
    }
}
