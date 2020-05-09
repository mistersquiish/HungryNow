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
            Image(systemName: "xmark.seal")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
            Text("Failed to Add")
                .customFont(name: "Chivo-Regular", style: .headline)
                .foregroundColor(Color.white)
            if (error != nil) {
                Text(error!.localizedDescription)
                    .customFont(name: "Chivo-Regular", style: .subheadline)
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
                .customFont(name: "Chivo-Regular", style: .headline)
                .foregroundColor(Color.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("accent2"))
    }
}
