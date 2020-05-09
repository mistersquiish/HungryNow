//
//  Alerts.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/30/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI

struct ErrorAlert: View {
    var error: Error?
    @Binding var showingErrorPopup: Bool
    
    var body: some View {
//        VStack {
//            if (error != nil) {
//                if error is YelpAPIError {
//                    Text("Error")
//                    Text(error!.localizedDescription)
//                }
//
//                if error is NotificationError {
//                    Text("Error")
//                    Text(error!.localizedDescription)
//                }
//
//                if error is SearchError {
//                    Text("Error")
//                    Text(error!.localizedDescription)
//                }
//
//            } else {
//                Text("?")
//            }
//            Button(action: {
//                self.showingErrorPopup = false
//            }) {
//                Text("Ok")
//                .frame(width: 200, height: 50)
//                .background(Color.gray)
//            }
//        }
        
        VStack {
            Image(systemName: "xmark.seal")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
            Text("Failed to Add")
                .font(.custom("Chivo-Regular", size: 18))
                .foregroundColor(Color.white)
            if (error != nil) {
//                if error is YelpAPIError {
//                    Text(error!.localizedDescription)
//                }
//
//                if error is NotificationError {
//                    Text(error!.localizedDescription)
//                }
//
//                if error is SearchError {
//                    Text(error!.localizedDescription)
//                }
                Text(error!.localizedDescription)
                    .font(.custom("Chivo-Regular", size: 12))
                    .foregroundColor(Color.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red)
        
    }
}

struct SuccessAlert: View {
    @Binding var showingSuccessPopup: Bool
    var vcDelegate: UIViewController?
        
    var body: some View {
        VStack {
            Image(systemName: "checkmark.seal")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
            Text("Successfull Added")
                .font(.custom("Chivo-Regular", size: 18))
                .foregroundColor(Color.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("accent2"))
    }
}

struct OkButton: View {
    var body: some View {
        HStack {
            Text("OK")
                .fontWeight(.semibold)
                .font(.custom("Chivo-Regular", size: 30))
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(Color("accent"))
        .cornerRadius(40)
    }
}
