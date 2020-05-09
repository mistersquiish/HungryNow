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
    
    let locMan = LocationManager()
    let mapError = MapError()
    
    // State variables
    @State var showingErrorPopup = false
    @State var error: Error?
    
    @IBSegueAction func addSwiftUIErrorView(_ coder: NSCoder) -> UIViewController? {
        let hostingController = UIHostingController(coder: coder, rootView: MapErrorView(mapError: mapError))
        hostingController?.view.backgroundColor = UIColor.clear
        return hostingController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let regionRadius: CLLocationDistance = 1000
        let center = MKCoordinateRegion(center: locMan.getCurrentLocation()!.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(center, animated: false)
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.restaurant, .cafe, .brewery, .bakery])
    }

    @IBAction func searchButton(_ sender: Any) {
        searchArea()
    }

    func searchArea() {
        mapError.showingErrorPopup = true
    }
}

struct MapErrorView: View {
    @ObservedObject var mapError: MapError
    
    var body: some View {
        VStack {
            Text("sdf")
        }.background(Color.red)
        .popup(isPresented: $mapError.showingErrorPopup, type: .toast, position: .bottom, autohideIn: 2) {
            ErrorAlert(error: self.mapError.error, showingErrorPopup: self.$mapError.showingErrorPopup)
        }
    }
}

class MapError: ObservableObject {
    @Published var showingErrorPopup = false
    var error: Error? = nil
}
