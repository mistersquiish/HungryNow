//
//  RestaurantRowComponents.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/8/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct RestaurantInfoView: View {
    var name: String
    var rating: Float
    var reviewCount: Int
    var price: String
    var address: String
    var city: String
    var distance: Float
    
    init(restaurantVM: RestaurantViewModel?, savedRestaurantVM: SavedRestaurantViewModel?) {
        if let restaurantVM = restaurantVM {
            self.name = restaurantVM.name
            self.rating = restaurantVM.rating
            self.reviewCount = restaurantVM.reviewCount
            self.price = restaurantVM.price
            self.address = restaurantVM.address
            self.city = restaurantVM.city
            self.distance = restaurantVM.distance
        } else {
            self.name = savedRestaurantVM!.name
            self.rating = savedRestaurantVM!.rating
            self.reviewCount = savedRestaurantVM!.reviewCount
            self.price = savedRestaurantVM!.price
            self.address = savedRestaurantVM!.address
            self.city = savedRestaurantVM!.city
            self.distance = savedRestaurantVM!.distance
        }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
                Text(name)
                    .customFont(name: "Chivo-Regular", style: .headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .foregroundColor(Color("font"))
                    .frame(maxWidth: 220, alignment: .leading)
            
            HStack (alignment: .center, spacing: 5) {
                Text(String("\(rating)"))
                    .foregroundColor(Color("font"))
                    .customFont(name: "Chivo-Regular", style: .headline)
//                    Image(systemName: "star.fill")
                YelpRating(rating: rating)
                    .frame(width: 90, height: 15)
                    .foregroundColor(Color.yellow)
                Text(String("\(reviewCount)"))
                Text("•").font(.custom("Chivo-Regular", size: 8)).foregroundColor(Color("subheading"))
                Text(price)
            }
//            HStack {
//
//                Text("•").font(.custom("Chivo-Regular", size: 8)).foregroundColor(Color("subheading"))
//            }
            
            Text(address)
                .lineLimit(1)
            Text(city)
            Text(String(format: "%.2f mi", distance)).frame(width: 100, alignment: .leading)
        }.customFont(name: "Chivo-Regular", style: .subheadline)
    }
}
