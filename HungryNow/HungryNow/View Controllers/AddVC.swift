//
//  AddVC.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit
import CoreLocation

class AddVC: UIViewController {

    @IBOutlet weak var popUpContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var restaurants: [Restaurant] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    // Drag to dismiss variables
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableViewDelegates()
        
        // add searchController
        setSearchBarDelegates()
        popUpContainer.addSubview(searchController.searchBar)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Restaurants"
//        navigationItem.searchController = searchController
        searchController.searchBar.showsCancelButton = false
        definesPresentationContext = true
        
        // Ask for location permission
        Location.locationManager.delegate = self
        Location.locationManager.requestWhenInUseAuthorization()
        
        // Drag to dismiss Modal View
        popUpContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))

        
        // UI changes
        tableView.rowHeight = 145
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getRestaurants() {
        retriveCurrentLocation()
        if let location = Location.locationManager.location {
            YelpAPI.getSearch(query: searchController.searchBar.text!, cllocation: location)  { (restaurants: [Restaurant]?, error: Error?) in
                if error != nil {
                    print(error!)
                } else if let restaurants = restaurants {
                    self.restaurants = restaurants
                    // Reload the tableView now that there is new data
                    self.tableView.reloadData()
                }
            }
        } else {
            print("no location enabled")
        }
    }
    
    func retriveCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            // show alert to user telling them they need to allow location data to use some feature of your app
            return
        }
        
        // if haven't show location permission dialog before, show it to user
        if(status == .notDetermined){
            Location.locationManager.requestWhenInUseAuthorization()
            
            // if you want the app to retrieve location data even in background, use requestAlwaysAuthorization
            // locationManager.requestAlwaysAuthorization()
            return
        }
        
        // at this point the authorization status is authorized
        // request location data once
        Location.locationManager.requestLocation()
        
        // start monitoring location data and get notified whenever there is change in location data / every few seconds, until stopUpdatingLocation() is called
        // locationManager.startUpdatingLocation()
    }
    
    // dismiss modal view
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
            
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }

}

extension AddVC: UITableViewDelegate, UITableViewDataSource {
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantAddCell", for: indexPath) as! RestaurantAddCell
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.addressLabel.text = restaurants[indexPath.row].address
        cell.reviewsCountLabel.text = String(describing: restaurants[indexPath.row].reviewCount)
        cell.backgroundColor = UIColor.yellow
        return cell
    }
}

extension AddVC: UISearchBarDelegate {
    func setSearchBarDelegates() {
        searchController.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getRestaurants()
    }
}

extension AddVC: CLLocationManagerDelegate {
    // called when the authorization status is changed for the core location permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")
        
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
        case .restricted:
            print("parental control setting disallow location data")
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
        @unknown default:
            print("unknown status cahnge")
        }
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
