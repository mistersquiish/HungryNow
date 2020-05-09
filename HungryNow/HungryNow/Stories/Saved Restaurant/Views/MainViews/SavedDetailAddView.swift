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
    
    var body: some View {
        ZStack {
            Color("background").edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button (action: {
                        self.mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .accentColor(Color(UIColor.black))
                    }
                    .padding(.top, 25)
                    .padding(.leading, 25)
                    
                    Spacer()
                }
                
                AddNotificationView(confirmNewNotification: ConfirmNewNotification.Add, notifications: notifications, restaurant: savedRestaurantVM.restaurant, showingErrorPopup: $showingErrorPopup, showingSuccessPopup: $showingSuccessPopup, error: $error)
                //Spacer()
            }
        }.foregroundColor(Color("font"))
        
        .popup(isPresented: $showingErrorPopup, type: .toast, position: .bottom, autohideIn: 4) {
            ErrorAlert(error: self.error, showingErrorPopup: self.$showingErrorPopup)
        }
            
        .popup(isPresented: $showingSuccessPopup, type: .toast, position: .bottom, autohideIn: 2) {
            SuccessAlert(showingSuccessPopup: self.$showingSuccessPopup, vcDelegate: nil)
        }
    }
}


