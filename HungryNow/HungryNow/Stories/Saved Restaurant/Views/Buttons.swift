//
//  Buttons.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/6/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

enum RestaurantButtonType {
    case Direction
    case Phone
    case Edit
}

struct RestaurantButton: View {
    var buttonType: RestaurantButtonType
    var savedRestaurantVM: SavedRestaurantViewModel?
    @Binding var showingNotifications: Bool
    
    init(buttonType: RestaurantButtonType, savedRestaurantVM: SavedRestaurantViewModel?, showingNotifications: Binding<Bool>?) {
        self.buttonType = buttonType
        self.savedRestaurantVM = savedRestaurantVM
        
        if showingNotifications != nil {
            self._showingNotifications = showingNotifications!
        } else {
            self._showingNotifications = Binding.constant(false)
        }
    }
    
    var body: some View {
        Group {
            if buttonType == .Direction {
                DirectionsButton(savedRestaurantVM: savedRestaurantVM!)
            } else if buttonType == .Phone {
                PhoneButton(savedRestaurantVM: savedRestaurantVM!)
            } else {
                EditButton(showingNotifications: $showingNotifications)
            }
            
        }.inExpandingRectangle().border(Color.red)
        
    }
}

struct DirectionsButton: View {
    var savedRestaurantVM: SavedRestaurantViewModel
    var query: String
    
    init(savedRestaurantVM: SavedRestaurantViewModel) {
        self.savedRestaurantVM = savedRestaurantVM
        
        var query = savedRestaurantVM.name + " " + savedRestaurantVM.address + " " + savedRestaurantVM.city
        query = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        self.query = query
    }
    
    var body: some View {
        HStack {
            Image(systemName: "location")
            Button(action: {
                // Try GoogleMaps first
                if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(self.query)")!, options: [:], completionHandler: nil)
                }
                // Try AppleMaps
                else if  UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com/")!) {
                    UIApplication.shared.open(URL(string:"http://maps.apple.com/?address=\(self.query)")!, options: [:], completionHandler: nil)
                }
                // Open Google Maps on browser
                else {
                    UIApplication.shared.open(URL(string: "http://maps.google.com/maps?daddr=\(self.query)")!, options: [:], completionHandler: nil)
                }
            }) {
                Text("Directions").font(.footnote)
                .foregroundColor(.white)
                .padding()
            }
        }
    }
}

struct PhoneButton: View {
    var savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel://\(self.savedRestaurantVM.phone)") {
               UIApplication.shared.open(url)
             }
        }) {
            Text("Call").foregroundColor(.white)
            .padding()
        }
    }
}

struct EditButton: View {
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: {
            self.showingNotifications.toggle()
        }) {
            Text("Edit").foregroundColor(.white)
            .padding()
        }
    }
}

struct ActionButton: View {
    @State private var showingSheet = false
    var notifications: Notifications
    var savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 20, height: 4)
                .rotationEffect(Angle(degrees: 90.0))
                .padding(.top, 15)
        }.actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text(savedRestaurantVM.name), message: Text("\(savedRestaurantVM.address) \(savedRestaurantVM.city)"), buttons: [
                .destructive(Text("Delete")) { self.removeRestaurant() },
                .cancel()
            ])
                 
        }
        
    }
    
    private func removeRestaurant() {
        // clear notification
        notifications.removeNotifications(restaurantID: savedRestaurantVM.id)
        
        // clear core data
        CoreDataManager.deleteRestaurant(restaurantID: savedRestaurantVM.id)
    }
}
