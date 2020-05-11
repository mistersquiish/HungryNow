//
//  ContestedLocation.swift
//  HungryNow
//
//  Created by Henry Vuong on 5/11/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import MapKit

class ContestedLocation {
    static func updateLocation(mv: MKMapView, oldAnnotations: [MKAnnotation]) {
        // construct new annotations
        let newAnnotations = ContestedAnnotationTool.annotationsByDistributingAnnotations(annotations: oldAnnotations) { (oldAnnotation:MKAnnotation, newCoordinate:CLLocationCoordinate2D) in
            
            if let restaurantAnnotation = oldAnnotation as? RestaurantAnnotation {
                return constructRestaurantAnnotation(title: restaurantAnnotation.title!, restaurant: restaurantAnnotation.restaurant, coordinate: newCoordinate)
            } else {
                return oldAnnotation
            }
            
        }
        mv.addAnnotations(newAnnotations)
    }
    
    static private func constructRestaurantAnnotation(title: String, restaurant: Restaurant, coordinate: CLLocationCoordinate2D) -> RestaurantAnnotation {
        let p = RestaurantAnnotation(title: title, restaurant: restaurant, coordinate: coordinate)
        return p
    }
    
    static private func constructAnnotation(title: String?, coordinate: CLLocationCoordinate2D) -> MKAnnotation {
        let p = MKPointAnnotation()
        p.title = title
        p.coordinate = coordinate
        return p
    }
}

public struct ContestedAnnotationTool {
    
    private static let radiusOfEarth = Double(6378100)
    
    typealias annotationRelocator = ((_ oldAnnotation:MKAnnotation, _ newCoordinate:CLLocationCoordinate2D) -> (MKAnnotation))
    
    static func annotationsByDistributingAnnotations(annotations: [MKAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MKAnnotation] {
        
        // 1. group the annotations by coordinate
        
        let coordinateToAnnotations = groupAnnotationsByCoordinate(annotations: annotations)
        
        // 2. go through the groups and redistribute
        
        var newAnnotations = [MKAnnotation]()
        
        for (_, annotationsAtCoordinate) in coordinateToAnnotations {
            
            let newAnnotationsAtCoordinate = ContestedAnnotationTool.annotationsByDistributingAnnotationsContestingACoordinate(annotations: annotationsAtCoordinate, constructNewAnnotationWithClosure: ctor)
            
            newAnnotations.append(contentsOf: newAnnotationsAtCoordinate)
        }

        return newAnnotations
    }
    
    private static func groupAnnotationsByCoordinate(annotations: [MKAnnotation]) -> [CLLocationCoordinate2D: [MKAnnotation]] {
        var coordinateToAnnotations = [CLLocationCoordinate2D: [MKAnnotation]]()
        for annotation in annotations {
            let coordinate = annotation.coordinate
            let annotationsAtCoordinate = coordinateToAnnotations[coordinate] ?? [MKAnnotation]()
            coordinateToAnnotations[coordinate] = annotationsAtCoordinate + [annotation]
        }
        return coordinateToAnnotations
    }
    
    private static func annotationsByDistributingAnnotationsContestingACoordinate(annotations: [MKAnnotation], constructNewAnnotationWithClosure ctor: annotationRelocator) -> [MKAnnotation] {
        
        var newAnnotations = [MKAnnotation]()
        
        let contestedCoordinates = annotations.map{ $0.coordinate }
        
        let newCoordinates = coordinatesByDistributingCoordinates(coordinates: contestedCoordinates)
        
        for (i, annotation) in annotations.enumerated() {
            
            let newCoordinate = newCoordinates[i]
            
            let newAnnotation = ctor(annotation, newCoordinate)
            
            newAnnotations.append(newAnnotation)
        }
        
        return newAnnotations
    }
    
    private static func coordinatesByDistributingCoordinates(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        
        if coordinates.count == 1 {
            return coordinates
        }
        
        var result = [CLLocationCoordinate2D]()
        
        let distanceFromContestedLocation: Double = 3.0 * Double(coordinates.count) / 2.0
        let radiansBetweenAnnotations = (Double.pi * 2) / Double(coordinates.count)
        
        for (i, coordinate) in coordinates.enumerated() {
            
            let bearing = radiansBetweenAnnotations * Double(i)
            let newCoordinate = calculateCoordinateFromCoordinate(coordinate: coordinate, onBearingInRadians: bearing, atDistanceInMetres: distanceFromContestedLocation)
            
            result.append(newCoordinate)
        }
        
        return result
    }
    
    private static func calculateCoordinateFromCoordinate(coordinate: CLLocationCoordinate2D, onBearingInRadians bearing: Double, atDistanceInMetres distance: Double) -> CLLocationCoordinate2D {
        
        let coordinateLatitudeInRadians = coordinate.latitude * Double.pi / 180;
        let coordinateLongitudeInRadians = coordinate.longitude * Double.pi / 180;
        
        let distanceComparedToEarth = distance / radiusOfEarth;
        
        let resultLatitudeInRadians = asin(sin(coordinateLatitudeInRadians) * cos(distanceComparedToEarth) + cos(coordinateLatitudeInRadians) * sin(distanceComparedToEarth) * cos(bearing));
        let resultLongitudeInRadians = coordinateLongitudeInRadians + atan2(sin(bearing) * sin(distanceComparedToEarth) * cos(coordinateLatitudeInRadians), cos(distanceComparedToEarth) - sin(coordinateLatitudeInRadians) * sin(resultLatitudeInRadians));
        
        let latitude = resultLatitudeInRadians * 180 / Double.pi;
        let longitude = resultLongitudeInRadians * 180 / Double.pi;
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        get {
            return (latitude.hashValue&*397) &+ longitude.hashValue;
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine((latitude.hashValue&*397) &+ longitude.hashValue)
    }
    
    static public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
