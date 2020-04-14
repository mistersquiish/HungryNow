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
        
    //@ObservedObject var restaurantAddVM: RestaurantAddViewModel
    var restaurantVM: RestaurantViewModel
    @State private var selectedTime = DurationPickerTime(hour: 1, minute: 0)
    
    init(restaurantVM: RestaurantViewModel) {
        self.restaurantVM = restaurantVM
        //self.restaurantAddVM = RestaurantAddViewModel(restaurantVM: restaurantVM)
    }
    
    var body: some View {
        VStack (alignment: .center) {
            Text("When would you like to be notified?")
                .frame(maxHeight: 100, alignment: .top)
                .font(.title)
            DurationPickerView(time: $selectedTime)
            
            Text("Daily")
            
            SaveButton()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
        
}

struct SaveButton: View {
    var body: some View {
        Button( action: {
            print("save")
        }) {
            HStack {
                Text("Save")
                    .fontWeight(.semibold)
                    .font(.title)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
        }.padding()
    }
}

//struct SearchAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchAddView(restaurantVM: RestaurantViewModel(restaurant: <#Restaurant#>))
//    }
//}
