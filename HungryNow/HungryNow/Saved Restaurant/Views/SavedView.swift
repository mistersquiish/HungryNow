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
//            Button(action: {
//                let rest = SavedRestaurant(context: self.moc)
//                rest.id = UUID()
//                rest.name = "popeyes"
//
//                try? self.moc.save()
//            }) {
//                Text("add")
//            }
            VStack (alignment: .leading) {
                List(restaurants, id: \.id) { restaurant in
                    SavedRowView(restaurant: restaurant)
                }
            }
            .navigationBarTitle(Text("Saved Restaurants"))
        }
        
    }
}


struct SavedRowView: View {
    @State var showingAddView = false
    let restaurant: SavedRestaurant
//    var categories: String {
//        get {
//            var categories: String = ""
//            for category in restaurant.categories {
//                categories += category["title"]! + ", "
//            }
//            return String(categories.dropLast().dropLast())
//        }
//    }
    
    var body: some View {
        HStack (alignment: .top) {
//            ImageViewWidget(imageURL: restaurant.imageURL)
//                .frame(width: 125, height: 125)
//            VStack (alignment: .leading) {
//                Text(restaurant.name!).font(.headline)
//                HStack {
//                    Text(String("\(restaurant.rating) rating,"))
//                    Text(String("\(restaurant.reviewCount) reviews"))
//                    Text(restaurant.price)
//                }
//                Text(restaurant.address)
//                Text(restaurant.city)
//                Text(String(format: "%.2f mi", restaurant.distance)).font(.footnote)
//                Text(categories).font(.subheadline)
//            }
            Text("hi")
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
