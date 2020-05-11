//
//  MapView.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/10/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import SwiftUI
import MapKit

struct MainMapView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var restaurantListVM = RestaurantListViewModel()
    @FetchRequest(entity: SavedRestaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<SavedRestaurant>
    let vcDelegate: UIViewController
    
    @State var coordinate = LocationManager().getCurrentLocation()!.coordinate
    @State var showingRestaurantPopup = false
    @State var restaurantVMSelected = RestaurantViewModel()
    
    // Animations
    @State private var rowDraggedOffset = CGSize.zero
    @State private var dragIndicatorOffset = CGSize.zero
    
    let notifications: Notifications    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    MapView(center: $coordinate, restaurantListVM: restaurantListVM, restaurantVMSelected: $restaurantVMSelected, showingRestaurantPopup: $showingRestaurantPopup).onTapGesture {
                        self.showingRestaurantPopup = false
                    }
                    MapResultsView(restaurantListVM: restaurantListVM)
                    VStack {
                        SearchAreaButton(restaurantListVM: self.restaurantListVM, coordinate: $coordinate)
                        Spacer()
                        if showingRestaurantPopup && !restaurantListVM.noResults && !restaurantListVM.showingErrorPopup {
                            ZStack {
                                Rectangle().fill(Color("background"))
                                    .frame(maxWidth: .infinity, maxHeight: 30)
                                VStack {
                                    Capsule()
                                        .fill(Color(red: 220/255, green: 220/255, blue: 220/255 ))
                                        .frame(width: 50, height: 8)
                                        .opacity(0.90)
                                        .padding(.top, 5)
                                        .offset(y: self.dragIndicatorOffset.height)
                                    RestaurantRowView(restaurantVM: self.restaurantVMSelected, notifications: self.notifications, restaurants: self.restaurants, vcDelegate: self.vcDelegate)
                                }
                            }
                            
                            .animation(.spring())
                            .offset(y: self.rowDraggedOffset.height)
                            .gesture(DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        self.rowDraggedOffset = value.translation
                                    } else {
                                        self.dragIndicatorOffset = CGSize(width: 0, height: -10)
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height > 150 {
                                        self.showingRestaurantPopup = false
                                    }
                                    self.rowDraggedOffset = CGSize.zero
                                    self.dragIndicatorOffset = CGSize.zero
                                    
                                }
                            )
                        }

                        if restaurantListVM.noResults {
                            NoResultsView(noResultsMessage: NoResultsMessage.Location)
                        } else if restaurantListVM.showingErrorPopup {
                            ErrorAlert(error: self.restaurantListVM.error)
                        }
                    }

                }
                .background(Color.green)
                .navigationBarTitle(Text("Map"), displayMode: .inline)
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var center: CLLocationCoordinate2D
    @ObservedObject var restaurantListVM: RestaurantListViewModel
    @Binding var restaurantVMSelected: RestaurantViewModel
    @Binding var showingRestaurantPopup: Bool
    
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
        uiView.setCenter(center, animated: true)
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
            self.mapView.center = mapView.centerCoordinate
            if updateCount != restaurantListVM.updateCount {
                updateCount = restaurantListVM.updateCount
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
    @Binding var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Button (action: {
            self.restaurantListVM.onSearchTapped(query: nil, limit: 30, locationQuery: self.coordinate)
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
