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
        VStack {
            if (error != nil) {
                if error is YelpAPIError {
                    Text("Error")
                    Text(error!.localizedDescription)
                }
                
                if error is NotificationError {
                    Text("Error")
                    Text(error!.localizedDescription)
                }
                
                if error is SearchError {
                    Text("Error")
                    Text(error!.localizedDescription)
                }
                
            } else {
                Text("?")
            }
            Button(action: {
                self.showingErrorPopup = false
            }) {
                Text("Ok")
                .frame(width: 200, height: 50)
                .background(Color.gray)
            }
        }
        .frame(width: 250, height: 400)
        .background(Color(red: 0.85, green: 0.8, blue: 0.95))
        .cornerRadius(30.0)
        
    }
}

struct SuccessAlert: View {
    @Binding var showingSuccessPopup: Bool
    var vcDelegate: UIViewController?
    
    var body: some View {
        VStack {
            Text("Notification Added").font(.title)
            Text("Your notification has been added")
            
            Button(action: {
                if (self.vcDelegate != nil) {
                    self.vcDelegate!.dismiss(animated: true, completion: nil)
                } else {
                    self.showingSuccessPopup = false
                }
            }) {
                Text("Ok")
                .frame(width: 200, height: 50)
                .background(Color.gray)
            }
        }
        .frame(width: 250, height: 400)
        .background(Color(red: 0.85, green: 0.8, blue: 0.95))
        .cornerRadius(30.0)
    }
}
