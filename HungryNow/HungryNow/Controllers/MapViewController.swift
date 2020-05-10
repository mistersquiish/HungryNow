//
//  MapViewController.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/9/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var buttonAcitivityIndicator: UIActivityIndicatorView!
    
    let locMan = LocationManager()
    var mapErrorController: UIHostingController<MapErrorView>!
    
    var mapError = MapError()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        searchButton.layer.cornerRadius = 15
        searchButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        searchButton.titleLabel?.backgroundColor = UIColor(named: "accent")
        searchButton.titleLabel?.font =  UIFont(name: "Chivo-Regular", size: 15)
        // Shadow and Radius
        searchButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchButton.layer.shadowOpacity = 1.0
        searchButton.layer.shadowRadius = 0.0
        searchButton.layer.masksToBounds = false
        searchButton.layer.cornerRadius = 15
        
        // Turn off actiivty indicator
        buttonAcitivityIndicator.isHidden = true
        
        
        // Set center of Map
        let regionRadius: CLLocationDistance = 1000
        let center = MKCoordinateRegion(center: locMan.getCurrentLocation()!.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(center, animated: false)
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.restaurant, .cafe, .brewery, .bakery])
        
        // create MapErrorView
        self.mapErrorController = UIHostingController(rootView: MapErrorView(mapError: mapError))
        mapErrorController.view.translatesAutoresizingMaskIntoConstraints = false
        mapErrorController.view.backgroundColor = UIColor.green
        self.view.addSubview(mapErrorController.view)
        self.addChild(mapErrorController)
        
        let constraints = [
            mapErrorController.view.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 0),
            mapErrorController.view.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: 0),
            mapErrorController.view.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0),
            mapErrorController.view.heightAnchor.constraint(equalToConstant: 125)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @IBAction func searchButton(_ sender: Any) {
        // Show searching UI
        toggleSearchButton()
        searchArea()
    }

    func searchArea() {
        let mapCenter = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        YelpAPI.getSearch(query: "sdfasdf", cllocation: mapCenter) { (restaurants: [Restaurant]?, error: Error?) in
            if let restaurants = restaurants {
                if restaurants.count == 0 {
                    self.mapError.error = SearchError.NoBusinesses
                    self.showErrorView()
                } else {
                    print(restaurants.count)
                }
            } else if let error = error {
                self.mapError.error = error
                self.showErrorView()
            }
            self.toggleSearchButton()
        }
        
        
        
    }
    
    private func toggleSearchButton() {
        searchButton.isEnabled.toggle()
        buttonAcitivityIndicator.isHidden.toggle()
        
        if buttonAcitivityIndicator.isAnimating {
            buttonAcitivityIndicator.stopAnimating()
        } else {
            buttonAcitivityIndicator.startAnimating()
        }
        
        if searchButton.titleLabel?.text == " " {
            searchButton.setTitle("Search Area", for: .normal)
        } else {
            searchButton.setTitle(" ", for: .normal)
        }
        
    }
    
    private func showErrorView() {
        // Reveal hidden Error View
        self.mapErrorController.view.isHidden = false
        let translationY = 125
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            self.mapErrorController.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(-1 * translationY))
        }, completion: nil)
        
        // Dismiss Error after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.mapErrorController.view.isHidden = true
            self.mapErrorController.view.transform = CGAffineTransform(translationX: 0, y: CGFloat(translationY))
        }
    }
}

struct MapErrorView: View {
    @ObservedObject var mapError: MapError

    var body: some View {
        VStack {
            Spacer()
            if isNoResultsError() {
                NoResultsView(noResultsMessage: NoResultsMessage.Location)
            } else {
                ErrorAlert(error: mapError.error)
            }
            
        }
        
    }
    
    func isNoResultsError() -> Bool {
        guard let searchError = mapError.error as? SearchError else { return false }
        switch searchError {
        case .NoBusinesses:
            return true
        default:
            return false
        }
    }
}

class MapError: ObservableObject {
    @Published var error: Error?
}
