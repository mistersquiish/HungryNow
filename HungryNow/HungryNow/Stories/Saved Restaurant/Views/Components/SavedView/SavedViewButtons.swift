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
    
    public var systemName: String {
        switch self {
        case .Direction:
            return "location"
        case .Phone:
            return "phone"
        case .Edit:
            return "pencil"
        }
    }
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
            if self.buttonType == .Direction {
                DirectionsButton(savedRestaurantVM: self.savedRestaurantVM!)
            } else if self.buttonType == .Phone {
                PhoneButton(savedRestaurantVM: self.savedRestaurantVM!)
            } else {
                EditButton(showingNotifications: self.$showingNotifications)
            }
        }
        .font(.custom("Chivo-Regular", size: 15))
        .foregroundColor(Color("subheading"))
        .padding(.top, 5)
        .padding(.bottom, 5)
        .background(Color("background"))
        
    }
}

struct DirectionsButton: View {
    @State private var showingDirections = false
    
    var savedRestaurantVM: SavedRestaurantViewModel
    var query: String
    
    init(savedRestaurantVM: SavedRestaurantViewModel) {
        self.savedRestaurantVM = savedRestaurantVM
        
        var query = savedRestaurantVM.name + " " + savedRestaurantVM.address + " " + savedRestaurantVM.city
        query = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        self.query = query
    }
    
    var body: some View {
            Button(action: {
                self.showingDirections = true
            }) {
                HStack {
                    Image(systemName: RestaurantButtonType.Direction.systemName)
                    Text("Directions")
                }.frame(maxWidth: .infinity)
                
            }
            .actionSheet(isPresented: $showingDirections) {
            ActionSheet(title: Text(savedRestaurantVM.name), message: Text("\(savedRestaurantVM.address) \(savedRestaurantVM.city)"), buttons: [
                .default(Text("Google Maps")) {
                    if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                        UIApplication.shared.open(URL(string:"comgooglemaps://?daddr=\(self.query)")!, options: [:], completionHandler: nil)
                    } else {
                        // open google maps on browser
                        UIApplication.shared.open(URL(string: "http://maps.google.com/maps?daddr=\(self.query)")!, options: [:], completionHandler: nil)
                    }
                },
                .default(Text("Apple Maps")) {
                    if  UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com/")!) {
                        UIApplication.shared.open(URL(string:"http://maps.apple.com/?address=\(self.query)")!, options: [:], completionHandler: nil)
                    }
                },
                .cancel()
            ])
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
            HStack {
                Image(systemName: RestaurantButtonType.Phone.systemName)
                Text("Call")
            }.frame(maxWidth: .infinity)
        }
    }
}

struct EditButton: View {
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: {
            self.showingNotifications.toggle()
        }) {
            HStack {
                Image(systemName: RestaurantButtonType.Edit.systemName)
                Text("Edit")
            }.frame(maxWidth: .infinity)
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
                 
        }.foregroundColor(Color("subheading"))
        
    }
    
    private func removeRestaurant() {
        // clear notification
        notifications.removeNotifications(restaurantID: savedRestaurantVM.id)
        
        // clear core data
        CoreDataManager.deleteRestaurant(restaurantID: savedRestaurantVM.id)
    }
}
