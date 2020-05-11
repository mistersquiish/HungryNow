//
//  LocationManager.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func getCurrentLocation() -> CLLocation? {
        retriveCurrentLocation()
        if let location = locationManager.location {
             return location
            // Austin Location
//            return CLLocation(latitude: CLLocationDegrees(exactly: 30.285052)!, longitude: CLLocationDegrees(exactly: -97.741729)!)
        } else {
            return nil
        }
    }
    
    private func retriveCurrentLocation() {
            let status = CLLocationManager.authorizationStatus()
            
            if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
                // show alert to user telling them they need to allow location data to use some feature of your app
                return
            }
            
            // if haven't show location permission dialog before, show it to user
            if(status == .notDetermined){
                locationManager.requestWhenInUseAuthorization()
                
                // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
                // locationManager.requestAlwaysAuthorization()
                return
            }
            
            // at this point the authorization status is authorized
            // request location data once
            locationManager.requestLocation()
            
            // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
            // locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // called when the authorization status is changed for the core location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("location manager authorization status changed")
//        
//        switch status {
//        case .authorizedAlways:
//            print("user allow app to get location data when app is active or in background")
//        case .authorizedWhenInUse:
//            print("user allow app to get location data only when app is active")
//        case .denied:
//            print("user tap 'disallow' on the permission dialog, cant get location data")
//        case .restricted:
//            print("parental control setting disallow location data")
//        case .notDetermined:
//            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
//        @unknown default:
//            print("unknown status cahnge")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
        
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
}
