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

class YelpAPI {
    static let yelpAPI: String = "https://api.yelp.com/v3/"
    static let yelpClientID: String = "linRbg0iHogjirbBxD-omw"
    static let yelpAPIKey: String = "KT_bxS5gMkwkqOweJ-DLtwJg3WaTwwLvQhaPINQgx7bGHyP3EZi_K7ZjfmCfD9xPXE8ACtxjseKOchixoxxTrsyjQjtqVmeyJiLGQ8Km9DYGF9bwD_BXx35bb3OPXnYx"
    
    static func getSearch(query: String, cllocation: CLLocation, completion: @escaping ([Restaurant]?, Error?) -> ()) {
        let requestURL: String = yelpAPI + "businesses/search"
        let radius: Int = 40000
        
        let header = [
            "Authorization": "Bearer \(yelpAPIKey)"
        ]
        
        let parameters = [
            "term": query,
            "latitude": cllocation.coordinate.latitude,
            "longitude": cllocation.coordinate.longitude,
            "radius": radius,
            "sort_by": "distance",
            "limit": 1,
            "categories": "food,restaurants"
        ] as [String : Any]
        
        Alamofire.request(requestURL,
                          method: .get,
                          parameters: parameters,
                          headers: header).response { response in
                            if let data = response.data {
                                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                                let restaurantsDictionary = dataDictionary["businesses"] as! [[String: Any]]
                                
                                let restaurants = Restaurant.restaurants(dictionaries: restaurantsDictionary)
                                completion(restaurants, nil)
                            } else {
                                print("error: no data")
                                completion(nil, response.error)
                            }
        }
    }
    
    static func getHours(restaurant: Restaurant, completion: @escaping (Hours?, Error?) -> ()) {
        let requestURL: String = yelpAPI + "businesses/" + restaurant.id
        
        let header = [
            "Authorization": "Bearer \(yelpAPIKey)"
        ]
        
        Alamofire.request(requestURL,
                          method: .get,
                          headers: header).response { response in
                            if let data = response.data {
                                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                                
                                guard let openDictionary = dataDictionary["hours"] as? [[String: Any]] else { completion(nil, YelpAPIError.NoHours)
                                    return
                                }
                                guard let hoursDictionary = openDictionary[0]["open"] as? [[String: Any]] else {
                                    completion(nil, YelpAPIError.NoHours)
                                    return
                                }
                                completion(Hours(times: hoursDictionary), nil)
                                
                            } else {
                                print("error: no data")
                                completion(nil, response.error)
                            }
        }
    }
}

