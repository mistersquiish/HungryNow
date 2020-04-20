//
//  SearchDetailView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/13/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

/// View for the search add view of a searched restaurant
struct SearchAddView : View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        
    var restaurantVM: RestaurantViewModel
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
    
    init(restaurantVM: RestaurantViewModel) {
        self.restaurantVM = restaurantVM
        //self.restaurantAddVM = RestaurantAddViewModel(restaurantVM: restaurantVM)
    }
    
    var body: some View {
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
            
            SaveButton(restaurantVM: restaurantVM, selectedDays: selectedDays, selectedTime: $selectedTime)
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
        })
    }
        
}

struct DayButton: View {
    
    let day: String
    @Binding var toggled: Bool
    @State var buttonHighlighting = Color.gray

    var body: some View {
        Button(action: {
            self.toggled.toggle()
            if self.toggled {
                self.buttonHighlighting = Color.blue
            } else {
                self.buttonHighlighting = Color.gray
            }
        }) {
            Text(day)
                .font(.system(size: 18))
                .padding(10)
                .background(buttonHighlighting)
                .foregroundColor(Color.black)
                .mask(Circle())
        }
    }
}

struct SaveButton: View {
    
    var restaurantVM: RestaurantViewModel
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
                    NotificationManager.createRestaurantNotification(restaurant: self.restaurantVM.restaurant, selectedDays: self.selectedDays, selectedTime: self.selectedTime) { (success: Bool, error: Error?) in
                        
                        // Save restaurant info and notification id
                        CoreDataManager.saveRestaurant(restaurant: self.restaurantVM.restaurant, notificatonID: "placeholder")
                    }
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
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
        }.padding()
    }
}

//struct SearchAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchAddView(restaurantVM: RestaurantViewModel(restaurant: <#Restaurant#>))
//    }
//}
