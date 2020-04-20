//
//  FavoriteView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/18/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI

struct SavedView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: SavedRestaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<SavedRestaurant>
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                List(restaurants, id: \.id) { savedRestaurant in
                    SavedRowView(savedRestaurant: savedRestaurant)
                }
            }
            .navigationBarTitle(Text("Saved Restaurants"))
        }
        
    }
}


struct SavedRowView: View {
    
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    var categories: String {
        get {
            var categories: String = ""
            for category in savedRestaurantVM.categories {
                categories += category["title"]! + ", "
            }
            return String(categories.dropLast().dropLast())
        }
    }
    
    init(savedRestaurant: SavedRestaurant) {
        let restaurant = Restaurant(savedRestaurant: savedRestaurant)
        savedRestaurantVM = SavedRestaurantViewModel(savedRestaurant: restaurant)
    }
    
    var body: some View {
        VStack {
            HStack (alignment: .top) {
                ImageViewWidget(imageURL: savedRestaurantVM.imageURL)
                    .frame(width: 125, height: 125)
                VStack (alignment: .leading) {
                    Text(savedRestaurantVM.name).font(.headline)
                    HStack {
                        Text(String("\(savedRestaurantVM.rating) rating,"))
                        Text(String("\(savedRestaurantVM.reviewCount) reviews"))
                        Text(savedRestaurantVM.price)
                    }
                    Text(savedRestaurantVM.address)
                    Text(savedRestaurantVM.city)
                    Text(String(format: "%.2f mi", savedRestaurantVM.distance)).font(.footnote)
                    Text(categories).font(.subheadline)
                }
            }
            HoursView(savedRestaurantVM: savedRestaurantVM)
            
        }
        
    }
}

struct HoursView: View {
    @ObservedObject var savedRestaurantVM: SavedRestaurantViewModel
    
    var body: some View {
        HStack {
            VStack {
                HourView(dayStr: "Sunday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Sunday])
                HourView(dayStr: "Monday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Monday])
                HourView(dayStr: "Tuesday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Tuesday])
                HourView(dayStr: "Wednesday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Wednesday])
            }
            VStack {
                HourView(dayStr: "Thursday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Thursday])
                HourView(dayStr: "Friday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Friday])
                HourView(dayStr: "Saturday", restaurantTimes: savedRestaurantVM.restaurantHours.days[.Saturday])
            }
        }
        
    }
}

struct HourView: View {
    var dayStr: String
    var restaurantTimes: [RestaurantTime]?
    
    var body: some View {
        HStack {
            Text(dayStr + ":")
            Text(restaurantTimes?[0].start ?? "N/A")
            Text(restaurantTimes?[0].end ?? "N/A")
        }
        
    }
}


#if DEBUG
struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
#endif
