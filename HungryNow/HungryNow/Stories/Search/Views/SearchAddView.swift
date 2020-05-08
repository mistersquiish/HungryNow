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
            AddNotificationView(confirmNewNotification: ConfirmNewNotification.Save, notifications: notifications, restaurant: restaurantVM.restaurant, showingErrorPopup: $showingErrorPopup, showingSuccessPopup: $showingSuccessPopup, error: $error)
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


