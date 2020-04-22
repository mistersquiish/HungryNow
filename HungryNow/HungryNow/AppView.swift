//
//  AppView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/21/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI
/// Deprecated as there is a TabBar bug with SwiftUI
//struct AppView: View {
//    @State var showSearchSheet: Bool = false
//    var body: some View {
//        ZStack {
//            GeometryReader { geometry in
//                TabView() {
//                    (SavedView())
//                    .tabItem {
//                        Image(systemName: "list.bullet.below.rectangle")
//                    }.tag(0)
//                    
//                    // Just a filler View. User should never see this
//                    Text("Hm.. You're not supposed to be here \n This is merely a holder view that isn't supposed to be accessed. Just close the app and don't come back here :)")
//                    .tabItem {
//                        Text(" ")
//                    }.tag(1)
//
//                    Text("Map?")
//                        .tabItem {
//                            Image(systemName: "square.grid.2x2")
//                    }.tag(2)
//                }
//                ZStack {
//                    Image(systemName: "")
//                        .resizable()
//                        .frame(width: geometry.size.width / 3, height: 100)
//                        .background(Rectangle().fill(Color.red))
//                        //.offset(x: geometry.size.width / 2 - 10, y: geometry.size.height - 40)
//                    Button(action: {
//                        self.showSearchSheet.toggle()
//                    }) {
//                        Image(systemName: "plus.circle")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .shadow(color: .gray, radius: 2, x: 0, y: 5)
//                    }
//                    .sheet(isPresented: self.$showSearchSheet) {
//                        SearchView()
//                    }
//                    .offset(x: 0, y: -40)
//                    
//                    
//                    
//                }.offset(x: geometry.size.width / 2 - (geometry.size.width / 6), y: geometry.size.height - 50)
//                
//            }
//
//        }
//
//    }
//}
