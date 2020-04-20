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
            Text(String(savedRestaurantVM.restaurantHours.days[.Monday]?[0].day.dayNum ?? 0))
            Text(savedRestaurantVM.restaurantHours.days[.Monday]?[0].start ?? "")
            
            Text(String(savedRestaurantVM.restaurantHours.days[.Saturday]?[0].day.dayNum ?? 0))
            Text(savedRestaurantVM.restaurantHours.days[.Saturday]?[0].start ?? "")
            
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
