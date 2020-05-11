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
    
    static func checkYelpErrors(dataDictionary: [String: Any]) -> YelpAPIError? {
        if let error = dataDictionary["error"] as? [String: Any] {
            guard let errorCode = error["code"] as? String else {
                return YelpAPIError.NoErrorCode
            }
            guard let errorDescription = error["description"] as? String else {
                return YelpAPIError.NoErrorCode
            }
            if errorCode == "INTERNAL_ERROR" {
                return YelpAPIError.InternalError
            }
            if errorCode == "ACCESS_LIMIT_REACHED" {
                return YelpAPIError.AccessLimitReached
            }
            if errorCode == "TOO_MANY_REQUESTS_PER_SECOND" {
                return YelpAPIError.TooManyRequestsPerSecond
            }
            if errorCode == "VALIDATION_ERROR" {
                if errorDescription == "Please specify a location or a latitude and longitude" {
                    return YelpAPIError.ValidationErrorLocation
                }
                return YelpAPIError.ValidationError(responseDescription: errorDescription)
            }
            return YelpAPIError.Unknown(errorDescription: errorDescription)
        }
        // no error
        return nil
    }
    
    static func checkRequestErrors(response: DefaultDataResponse) -> YelpAPIError? {
        if let error = response.error {
            return YelpAPIError.RequestFailed(error: error)
        }
        return nil
    }
    
    static func getSearch(query: String?, coordinate: CLLocationCoordinate2D, completion: @escaping ([Restaurant]?, Error?) -> ()) {
        let requestURL: String = yelpAPI + "businesses/search"
        let radius: Int = 40000
        
        let header = [
            "Authorization": "Bearer \(yelpAPIKey)"
        ]
        
        var parameters = [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "radius": radius,
            "sort_by": "distance",
            "limit": 10,
            "categories": "food,restaurants"
        ] as [String : Any]
        
        // add query if provided
        if let query = query {
            parameters["term"] = query
        }
        
        Alamofire.request(requestURL,
                          method: .get,
                          parameters: parameters,
                          headers: header).response { response in
            if let error = checkRequestErrors(response: response) {
                completion(nil, error)
                return
            }
            
            if let data = response.data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // check if returned response error
                if let error = checkYelpErrors(dataDictionary: dataDictionary) {
                    completion(nil, error)
                    return
                }
                
                guard let restaurantsDictionary = dataDictionary["businesses"] as? [[String: Any]] else {
                    completion(nil, YelpAPIError.NoBusinesses)
                    return
                }
                let restaurants = Restaurant.restaurants(dictionaries: restaurantsDictionary)
                completion(restaurants, nil)
            } else {
                print("error: no data")
                completion(nil, YelpAPIError.RequestFailed(error: response.error!))
            }
        } 
    }
    
    static func getHours(restaurantID: String, completion: @escaping (RestaurantHours?, Error?) -> ()) {
        let requestURL: String = yelpAPI + "businesses/" + restaurantID
        
        let header = [
            "Authorization": "Bearer \(yelpAPIKey)"
        ]
        
        Alamofire.request(requestURL,
                          method: .get,
                          headers: header).response { response in
            if let data = response.data {
                if let error = checkRequestErrors(response: response) {
                    completion(nil, error)
                    return
                }
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // check if returned response error
                if let error = checkYelpErrors(dataDictionary: dataDictionary) {
                    completion(nil, error)
                    return
                }
                
                // check if hours is in the request call
                guard let openDictionary = dataDictionary["hours"] as? [[String: Any]] else { completion(nil, YelpAPIError.NoHours)
                    return
                }
                guard let hoursDictionary = openDictionary[0]["open"] as? [[String: Any]] else {
                    completion(nil, YelpAPIError.NoHours)
                    return
                }
                completion(RestaurantHours(times: hoursDictionary), nil)
                
            } else {
                print("error: no data")
                completion(nil, YelpAPIError.RequestFailed(error: response.error!))
            }
        }
    }
    
    static func getDetails(restaurantID: String, completion: @escaping (Restaurant?, Error?) -> ()) {
        let requestURL: String = yelpAPI + "businesses/" + restaurantID
        
        let header = [
            "Authorization": "Bearer \(yelpAPIKey)"
        ]
        
        Alamofire.request(requestURL,
                          method: .get,
                          headers: header).response { response in
            if let error = checkRequestErrors(response: response) {
                print(restaurantID)
                completion(nil, error)
                return
            }
            
            if let data = response.data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // check if returned response error
                if let error = checkYelpErrors(dataDictionary: dataDictionary) {
                    completion(nil, error)
                    return
                }
                
                let restaurant = Restaurant(data: dataDictionary)
                
                // check if hours is in the request call
                guard let openDictionary = dataDictionary["hours"] as? [[String: Any]] else { completion(nil, YelpAPIError.NoHours)
                    return
                }
                guard let hoursDictionary = openDictionary[0]["open"] as? [[String: Any]] else {
                    completion(nil, YelpAPIError.NoHours)
                    return
                }
                
                restaurant.hours = RestaurantHours(times: hoursDictionary)
                
                completion(restaurant, nil)
                
            } else {
                print("error: no data")
                completion(nil, YelpAPIError.RequestFailed(error: response.error!))
            }
        }
    }
}

