//
//  YelpAPITests.swift
//  HungryNowTests
//
//  Created by Henry Vuong on 4/14/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import XCTest
@testable import HungryNow
import CoreLocation

class YelpAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    /// Tests the restaurant search
    func testGetRestaurantSearch() throws {
        let query = "mcdonald"
        let location = CLLocation(latitude: 30.294310, longitude: -97.737488)
        var apiCallExpectation: XCTestExpectation? = expectation(description: "Api call")
        
        // var to check
        var errorCheck: Error?
        var restaurantsCheck: [Restaurant]?
        
        YelpAPI.getSearch(query: query, coordinate: location.coordinate, limit: 10) { (restaurants: [Restaurant]?, error: Error?) in
            errorCheck = error
            restaurantsCheck = restaurants
            apiCallExpectation!.fulfill()
            apiCallExpectation = nil
            
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssert(errorCheck == nil)
            XCTAssert(restaurantsCheck != nil)
        }
    }
    
    /// Tests for when given location is invalid
    func testValidationErrorLocation() throws {
        let query = "mcdonald"
        let location = CLLocation(latitude: -111111, longitude: 22222)
        var apiCallExpectation: XCTestExpectation? = expectation(description: "Api call")
        
        // var to check
        var errorCheck: Error?
        var restaurantsCheck: [Restaurant]?
        
        YelpAPI.getSearch(query: query, coordinate: location.coordinate, limit: 10) { (restaurants: [Restaurant]?, error: Error?) in
            errorCheck = error
            restaurantsCheck = restaurants
            apiCallExpectation?.fulfill()
            apiCallExpectation = nil
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssert(errorCheck != nil)
            XCTAssert(restaurantsCheck == nil)
        }
    }
    
    /// Tests the get hours
    func testGetHours() throws {
        let restaurantID = "WavvLdfdP6g8aZTtbBQHTw" // id should return 7 hours for each day of the week
        var apiCallExpectation: XCTestExpectation? = expectation(description: "Api call")
        
        // var to check
        var errorCheck: Error?
        var hoursCheck: RestaurantHours?
        
        YelpAPI.getHours(restaurantID: restaurantID) { (hours: RestaurantHours?, error: Error?) in
            errorCheck = error
            hoursCheck = hours
            apiCallExpectation?.fulfill()
            apiCallExpectation = nil
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssert(hoursCheck != nil)
            XCTAssert(errorCheck == nil)

            guard let hours = hoursCheck else { return }
            XCTAssert(hours.days.count == 7)
          
            // test each day for hours
            testDay(testDay: Day.Monday, hours: hours)
            testDay(testDay: Day.Tuesday, hours: hours)
            testDay(testDay: Day.Wednesday, hours: hours)
            testDay(testDay: Day.Thursday, hours: hours)
            testDay(testDay: Day.Friday, hours: hours)
            testDay(testDay: Day.Saturday, hours: hours)
            testDay(testDay: Day.Sunday, hours: hours)
        }
        
        func testDay(testDay: Day, hours: RestaurantHours) {
            XCTAssert(hours.days[testDay] != nil)
            guard let day = hours.days[testDay] else { return }
            XCTAssert(day.count > 0)
            
            XCTAssert(Int(day[0].start)! >= 0 && Int(day[0].end)! <= 2400)
            XCTAssert(Int(day[0].end)! >= 0 && Int(day[0].end)! <= 2400)
            XCTAssert(day[0].day == testDay)
        }
    }

    /// Tests for when a Yelp API business detail call returns no hours
    func testGetNoHours() throws {
        let restaurantID = "tUoHDDfBaMIIGnEUsYccSg" // id should return no hours
        var apiCallExpectation: XCTestExpectation? = expectation(description: "Api call")
        
        // var to check
        var errorCheck: Error?
        var hoursCheck: RestaurantHours?
        
        YelpAPI.getHours(restaurantID: restaurantID) { (hours: RestaurantHours?, error: Error?) in
            errorCheck = error
            hoursCheck = hours
            apiCallExpectation?.fulfill()
            apiCallExpectation = nil
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssert(hoursCheck == nil)
            XCTAssert(errorCheck != nil)
        }
    }
}
