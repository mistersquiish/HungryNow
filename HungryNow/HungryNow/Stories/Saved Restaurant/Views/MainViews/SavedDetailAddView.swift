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
    
    // State variables for popups
    @State var showingErrorPopup = false
    @State var showingSuccessPopup = false
    @State var error: Error?
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
            
            AddNotificationView(confirmNewNotification: ConfirmNewNotification.Add, notifications: notifications, restaurant: savedRestaurantVM.restaurant, showingErrorPopup: $showingErrorPopup, showingSuccessPopup: $showingSuccessPopup, error: $error)
            Spacer()
        }
        .foregroundColor(Color("font"))
        .background(Color("background"))
        
        .popup(isPresented: $showingErrorPopup, autohideIn: 2) {
            ErrorAlert(error: self.error, showingErrorPopup: self.$showingErrorPopup)
        }
            
        .popup(isPresented: $showingSuccessPopup, autohideIn: 2) {
            SuccessAlert(showingSuccessPopup: self.$showingSuccessPopup, vcDelegate: nil)
        }
        
        
        
    }
        
}


