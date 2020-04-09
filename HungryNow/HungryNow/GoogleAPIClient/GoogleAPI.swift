//
//  File.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

/// Handle Google API requests
import Foundation
import Alamofire

class GoogleAPI {
    static let googleAPI: String = "https://maps.googleapis.com/maps/api/place/"
    static let googleAPIKey: String = "AIzaSyDdeUSzahHP5lrtVcYLuS3Op_OFxq7R9yE"
    
    
    static func getSearch(query: String) {
        let requestURL: String = googleAPI + "textsearch/json?"
        
        let parameters = [
            "key": googleAPIKey,
            "query": query,
            "inputtype": "textquery"
        ]
        
        Alamofire.request(requestURL,
                          method: .get,
                          parameters: parameters).response { response in
                            if let data = response.data {
                                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                                print(dataDictionary)
                                print("success")
                            } else {
                                print("error: no data")
                            }
        }
    }
}

