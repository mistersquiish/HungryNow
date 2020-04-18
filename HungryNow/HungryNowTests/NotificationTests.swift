//
//  NotificationTests.swift
//  HungryNowTests
//
//  Created by Henry Vuong on 4/18/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import XCTest
@testable import HungryNow
import CoreLocation

class NotificationTests: XCTestCase {
    
    /// Tests the full cycle of creating a restaurant notification (incomplete)
    func testRestaurantNotification() throws {
        let restaurantValues: [String: Any] = [
            "id": "pwoyyn26X85Rx230QEIdfQ",
            "name": "Popeyes Louisiana Kitchen",
            "address1": "206 Cohuila Loop",
            "city": "Laredo",
            "state": "TX",
            "country": "US",
            "rating": 5,
            "review_count": 2,
            "phone": "+19567291779",
            "price": "$",
            "distance": 0.89,
            "is_closed": false,
            "categories": [[
                    "alias": "hotdogs",
                    "title": "Fast Food"
                ]]
        ]
        let restaurant = Restaurant(data: restaurantValues)
        let selectedTime = DurationPickerTime(hour: 2, minute: 15)
        
        NotificationManager.createRestaurantNotification(restaurant: restaurant, selectedDays: [Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday], selectedTime: selectedTime) { (success: Bool?, error: Error?) in
            XCTAssert(success == true)
            XCTAssert(error == nil)
        }
    }
    
    func testCalculateNotificationTime() throws {
        func testTime(selectedTime: DurationPickerTime, restaurantTime: RestaurantTime, expectedDay: Day, expectedHour: Int, expectedMinute: Int) {
            
            
            let dateComponents = NotificationManager.calculateNotificationTime(restaurantTime: restaurantTime, selectedTime: selectedTime)
            XCTAssert(dateComponents.weekday == expectedDay.dayNum)
            XCTAssert(dateComponents.year == Calendar.current.component(.year, from: Date()))
            XCTAssert(dateComponents.timeZone == .current)
            XCTAssert(dateComponents.hour == expectedHour)
            XCTAssert(dateComponents.minute == expectedMinute)
            XCTAssert(dateComponents.weekdayOrdinal == nil)
            XCTAssert(dateComponents.day == nil)
            XCTAssert(dateComponents.month == nil)
        }
        
        let restaurantTimeValues: [String : Any] = [
            "is_overnight": false,
            "start": "1000",
            "end": "2300",
            "day": 1 // Tuesday
            ]
        let restaurantTime = RestaurantTime(timeData: restaurantTimeValues)
        
        let selectedTime1 = DurationPickerTime(hour: 2, minute: 15)
        testTime(selectedTime: selectedTime1, restaurantTime: restaurantTime, expectedDay: Day.Tuesday, expectedHour: 20, expectedMinute: 45)
        let selectedTime2 = DurationPickerTime(hour: 12, minute: 1)
        testTime(selectedTime: selectedTime2, restaurantTime: restaurantTime, expectedDay: Day.Tuesday, expectedHour: 10, expectedMinute: 59)
        let selectedTime3 = DurationPickerTime(hour: 23, minute: 25)
        testTime(selectedTime: selectedTime3, restaurantTime: restaurantTime, expectedDay: Day.Monday, expectedHour: 23, expectedMinute: 35)
        
        // change day to Sunday
        restaurantTime.day = Day.Sunday
        testTime(selectedTime: selectedTime1, restaurantTime: restaurantTime, expectedDay: Day.Sunday, expectedHour: 20, expectedMinute: 45)
        testTime(selectedTime: selectedTime2, restaurantTime: restaurantTime, expectedDay: Day.Sunday, expectedHour: 10, expectedMinute: 59)
        testTime(selectedTime: selectedTime3, restaurantTime: restaurantTime, expectedDay: Day.Saturday, expectedHour: 23, expectedMinute: 35)
    }

}
