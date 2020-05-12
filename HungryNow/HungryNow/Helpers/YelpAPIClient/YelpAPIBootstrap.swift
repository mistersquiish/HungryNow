//
//  YelpAPIBootstrap.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire

extension YelpAPI {
    static func bootstrap() {
        let hungryNowUrl: String = "https://hungrynow.herokuapp.com/"
        let hungryNowKey: String = "ajdsfaji10928cn8JFn8fn89nf87DBfBhdfh0Fh0DIFHh0f"

        // Check if user has already saved the API key from previous requests
        if let key = KeychainWrapper.standard.string(forKey: "yelpAPIKey") {
            yelpAPIKey = key
        }
        if let id = KeychainWrapper.standard.string(forKey: "yelpClientID") {
            yelpClientID = id
        }
        
        // Run a background task of retrieving the API key and updating the keychain with new ID and Key
        DispatchQueue.global(qos: .background).async {
            let requestURL = hungryNowUrl + "/api/yelpmeta"
            
            let header = [
                "Authorization": "Bearer \(yelpAPIKey)"
            ]
            
            let parameters = [
                "key": hungryNowKey
            ] as [String : Any]
            
            Alamofire.request(requestURL,
                              method: .get,
                              parameters: parameters,
                              headers: header).response { response in
                if let data = response.data {
                    do {
                        let dataDictionary = try (JSONSerialization.jsonObject(with: data, options: []) as! [String: Any])
                        
                        if let yelpKeys = dataDictionary["yelp"] as? [String: Any] {
                            KeychainWrapper.standard.set("\(yelpKeys["key"]!)", forKey: "yelpAPIKey")
                            KeychainWrapper.standard.set("\(yelpKeys["id"]!)", forKey: "yelpClientID")

                            yelpAPIKey = KeychainWrapper.standard.string(forKey: "yelpAPIKey")!
                            yelpClientID = KeychainWrapper.standard.string(forKey: "yelpClientID")!
                        } else {
                            print("error: no yelp data")
                        }
                        
                        
                    } catch {
                        print("error: failed on data parsing")
                    }
                    
                } else {
                    print("error: failed to connect to server")
                }
                
                                

                
            }
        }
    }
}
