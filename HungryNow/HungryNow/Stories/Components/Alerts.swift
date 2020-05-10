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
    //@Binding var showingErrorPopup: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.seal")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.white)
            Text("Error")
                .customFont(name: "Chivo-Regular", style: .headline)
                .foregroundColor(Color.white)
            if (error != nil) {
                Text(error!.localizedDescription)
                    .customFont(name: "Chivo-Regular", style: .subheadline)
                    .foregroundColor(Color.white)
            } else {
                Text("Unknown error. Please try again later.")
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

struct NoResultsView: View {
    var noResultsMessage: NoResultsMessage
    
    var body: some View {
        VStack (alignment: .center) {
            Text("No Results")
                .customFont(name: "Chivo-Regular", style: .title1)
            Text(noResultsMessage.message1)
                .customFont(name: "Chivo-Regular", style: .body)
            Text(noResultsMessage.message2)
                .customFont(name: "Chivo-Regular", style: .body)
        }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(Color("font"))
            .background(Color("background2"))
    }
}

enum NoResultsMessage {
    case Query
    case Location
    
    var message1: String {
        switch self {
        case .Query:
            return "Try searching with only alpha and"
        case .Location:
            return "Try searching a different"
        }
    }
    
    var message2: String {
        switch self {
        case .Query:
            return "and numerical characters."
        case .Location:
            return "location."
        }
    }
}
