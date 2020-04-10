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
import CoreLocation

class GoogleAPI {
    static let googleAPI: String = "https://maps.googleapis.com/maps/api/place/"
    static let googleAPIKey: String = "AIzaSyDdeUSzahHP5lrtVcYLuS3Op_OFxq7R9yE"
    
    
    static func getSearch(query: String, cllocation: CLLocation?, completion: @escaping ([Restaurant]?, Error?) -> ()) {
        let requestURL: String = googleAPI + "textsearch/json?"
        
        var location: String = "0,0"
        var radius: Int = 0
        if let cllocation = cllocation {
            location = "\(cllocation.coordinate.latitude),\(cllocation.coordinate.longitude)"
            radius = 50000
        }
        let parameters = [
            "key": googleAPIKey,
            "query": query,
            "inputtype": "textquery",
            "type": "food",
            "location": location,
            "radius": radius
        ] as [String : Any] 
        
        Alamofire.request(requestURL,
                          method: .get,
                          parameters: parameters).response { response in
                            if let data = response.data {
                                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                                let restaurantsDictionary = dataDictionary["results"] as! [[String: Any]]
                                
                                let restaurants = Restaurant.restaurants(dictionaries: restaurantsDictionary)
                                completion(restaurants, nil)
                            } else {
                                print("error: no data")
                                completion(nil, response.error)
                            }
        }
    }
}

