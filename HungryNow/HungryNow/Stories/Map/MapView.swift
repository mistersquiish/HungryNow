//
//  MapView.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/10/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import MapKit
import AVFoundation

// default location
let austinLocation = CLLocation(latitude: CLLocationDegrees(exactly: 30.285052)!, longitude: CLLocationDegrees(exactly: -97.741729)!)

struct MainMapView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var restaurantListVM = RestaurantListViewModel()
    @FetchRequest(entity: SavedRestaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<SavedRestaurant>
    let vcDelegate: UIViewController
    let locMan = LocationManager()
    let mapHelper = MapViewHelper(coordinate: LocationManager().getCurrentLocation()?.coordinate ?? austinLocation.coordinate)
    
//    @State var coordinate: CLLocationCoordinate2D = LocationManager().getCurrentLocation()?.coordinate ?? austinLocation.coordinate
    @State var showingRestaurantPopup = false
    @State var restaurantVMSelected = RestaurantViewModel()
    
    let notifications: Notifications
    
    init(vcDelegate: UIViewController, notifications: Notifications) {
        self.notifications = notifications
        self.vcDelegate = vcDelegate
        
        locMan.requestAuthorization()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView(restaurantListVM: restaurantListVM, restaurantVMSelected: $restaurantVMSelected, showingRestaurantPopup: $showingRestaurantPopup, mapHelper: mapHelper).onTapGesture {
                    self.showingRestaurantPopup = false
                }
                MapResultsView(restaurantListVM: restaurantListVM)
                YelpLogo()
                
                // Main Map UI
                VStack {
                    SearchAreaButton(restaurantListVM: self.restaurantListVM, mapHelper: mapHelper)
                    Spacer()
                    
                    // Restaurant pop up
                    if showingRestaurantPopup && !restaurantListVM.noResults && !restaurantListVM.showingErrorPopup {
                        MapRestaurantView(restaurantVMSelected: $restaurantVMSelected, showingRestaurantPopup: $showingRestaurantPopup, notifications: notifications, restaurants: restaurants, vcDelegate: vcDelegate)
                    }

                    // No results and Error Popup
                    if restaurantListVM.noResults {
                        NoResultsView(noResultsMessage: NoResultsMessage.Location)
                    } else if restaurantListVM.showingErrorPopup {
                        ErrorAlert(error: self.restaurantListVM.error)
                    }
                }
            }
            .navigationBarTitle(Text("Map"), displayMode: .inline)
        }
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    var center: CLLocationCoordinate2D = LocationManager().getCurrentLocation()?.coordinate ?? austinLocation.coordinate
    @ObservedObject var restaurantListVM: RestaurantListViewModel
    @Binding var restaurantVMSelected: RestaurantViewModel
    @Binding var showingRestaurantPopup: Bool
    @ObservedObject var mapHelper: MapViewHelper
    
    // Main methods
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        // set zoom
        // Set center of Map
        let regionRadius: CLLocationDistance = 1000
        let center = MKCoordinateRegion(center: self.center, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(center, animated: false)
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(excluding: [.restaurant, .cafe, .brewery, .bakery])
        
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.setCenter(mapHelper.coordinate, animated: true)
    }

    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self, restaurantListVM: restaurantListVM)
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        private let mapView: MapView
        private let restaurantListVM: RestaurantListViewModel
        private var updateCount: Int

        init(_ mapView: MapView, restaurantListVM: RestaurantListViewModel) {
            self.mapView = mapView
            self.restaurantListVM = restaurantListVM
            self.updateCount = restaurantListVM.updateCount
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.mapView.mapHelper.coordinate = mapView.centerCoordinate
            if updateCount != restaurantListVM.updateCount {
                updateCount = restaurantListVM.updateCount
                let allAnnotations = mapView.annotations
                mapView.removeAnnotations(allAnnotations)
                addAnnotations(mapView: mapView)
            }
        }
        
        //MARK: - Custom Annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is RestaurantAnnotation else { return nil }
            let _identifier = "test"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: _identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: _identifier)
                view.canShowCallout = false
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.tintColor = UIColor.green
                view.markerTintColor = UIColor(named: "accent")
                view.displayPriority = MKFeatureDisplayPriority.required
                view.glyphImage = #imageLiteral(resourceName: "missing-restaurant")
                return view
            }
            return view
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let restaurantAnnotation = view.annotation as? RestaurantAnnotation {
                self.mapView.restaurantVMSelected = RestaurantViewModel(restaurant: restaurantAnnotation.restaurant)
                self.mapView.restaurantListVM.showingErrorPopup = false
                self.mapView.restaurantListVM.noResults = false
                self.mapView.showingRestaurantPopup = true
            }
        }
                
        func addAnnotations(mapView: MKMapView) {
            var annotations: [RestaurantAnnotation] = []
            for restaurantVM in restaurantListVM.restaurants {
                let annotation = makeAnnotation(restaurant: restaurantVM.restaurant!)
                
                
                //mapView.addAnnotation(annotation)
                annotations.append(annotation)
            }
            
            ContestedLocation.updateLocation(mv: mapView, oldAnnotations: annotations)
        }
        
        private func makeAnnotation(restaurant: Restaurant) -> RestaurantAnnotation {
            let coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            let annotation = RestaurantAnnotation(title: restaurant.name, restaurant: restaurant, coordinate: coordinate)
            
            return annotation
        }
    }
}

struct SearchAreaButton: View {
    @ObservedObject var restaurantListVM: RestaurantListViewModel
    @ObservedObject var mapHelper: MapViewHelper
    
    var body: some View {
        Button (action: {
            self.restaurantListVM.onSearchTapped(query: nil, limit: 50, locationQuery: self.mapHelper.coordinate)
        }) {
            ZStack {
                if self.restaurantListVM.isLoading {
                    Indicator()
                } else {
                    Text("Search Area")
                }
            }
                .foregroundColor(Color.white)
                .font(.custom("Chivo-Regular", size: 15))
                .frame(width: 90, height: 10)
                .padding()
                .background(Color("accent"))
                .shadow(radius: 8)
                .cornerRadius(30)
            
        }.padding()
    }
}

struct MapResultsView: View {
    @ObservedObject var restaurantListVM: RestaurantListViewModel
    
    var body: some View {
        VStack {
            HStack {
                if (restaurantListVM.restaurants.count > 0) {
                    Text("\(restaurantListVM.restaurants.count) results")
                    .foregroundColor(Color("subheading"))
                    .font(.custom("Chivo-Regular", size: 14))
                    .padding()
                    .shadow(radius: 8)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct MapRestaurantView: View {
    @Binding var restaurantVMSelected: RestaurantViewModel
    @Binding var showingRestaurantPopup: Bool
    @ObservedObject var notifications: Notifications
    var restaurants: FetchedResults<SavedRestaurant>
    var vcDelegate: UIViewController
    
    // Animations
    @State private var rowDraggedDownOffset = CGSize.zero
    @State private var dragIndicatorOffset = CGSize.zero
    @State private var rowDraggedUpOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            Group {
                Rectangle().fill(Color("background")).frame(maxWidth: .infinity, maxHeight: 220)
                
                Group {
                    // needed for extra space animation
                    Rectangle().fill(Color("background")).frame(maxWidth: .infinity, maxHeight: 220)
                    VStack (spacing: 0) {
                        Capsule()
                        .fill(Color(red: 230/255, green: 230/255, blue: 230/255 ))
                        .frame(width: 50, height: 8)
                        .opacity(0.85)
                        .offset(y: self.dragIndicatorOffset.height)
                        .zIndex(1)
                        RestaurantRowView(restaurantVM: self.restaurantVMSelected, notifications: self.notifications, restaurants: self.restaurants, vcDelegate: self.vcDelegate)
                    }
                }
                .offset(y: self.rowDraggedUpOffset.height)
            }
            .animation(.spring())
            .offset(y: self.rowDraggedDownOffset.height)
            .gesture(DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        self.rowDraggedDownOffset = value.translation
                        // Remember, the drag indicator is offsetted by both its
                        // offset and the row offset
                        self.dragIndicatorOffset = CGSize(width: 0, height: 5)
                    } else {
                        self.rowDraggedUpOffset = CGSize(width: 0, height: -10)
                        // Remember, the drag indicator is offsetted by both its
                        // offset and the row offset
                        self.dragIndicatorOffset = CGSize(width: 0, height: -5)
                    }
                }
                .onEnded { value in
                    if value.translation.height > 150 {
                        // vibration
                        let impactGenerator = UIImpactFeedbackGenerator()
                        impactGenerator.impactOccurred()
                        self.showingRestaurantPopup = false
                    }
                    self.rowDraggedDownOffset = CGSize.zero
                    self.dragIndicatorOffset = CGSize.zero
                    self.rowDraggedUpOffset = CGSize.zero
                    
                }
            )
        }
    }
}

class MapViewHelper: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
