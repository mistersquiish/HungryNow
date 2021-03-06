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
                Spacer()
                AddNotificationView(confirmNewNotification: ConfirmNewNotification.Save, notifications: notifications, restaurant: restaurantVM.restaurant!, showingErrorPopup: $showingErrorPopup, showingSuccessPopup: $showingSuccessPopup, error: $error)
                Spacer()
            }
        }.foregroundColor(Color("font"))
            
        // Popup Views
        .popup(isPresented: $showingErrorPopup, type: .toast, position: .bottom, autohideIn: 4) {
            ErrorAlert(error: self.error)
        }
            
        .popup(isPresented: $showingSuccessPopup, type: .toast, position: .bottom, autohideIn: 2) {
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


