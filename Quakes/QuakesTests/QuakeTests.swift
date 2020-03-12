//
//  QuakeTests.swift
//  QuakesTests
//
//  Created by Paul Solt on 10/31/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import XCTest
@testable import Quakes

class QuakeTests: XCTestCase {

    // Use throws so you don't need do/catch
    func testQuake() throws {
        // Red, Green, Refactor
        // red = failing test
        // green = passing
        // refactor = clean up or organize
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let date = Date(timeIntervalSince1970: 1388620296020 / 1000.0)
        
        let quake = try decoder.decode(Quake.self, from: quakeData)
        // Assert(expected, actual)

        //XCTAssertEqual(1.29, quake.magnitude) // 1.29   == 1.28888889  FAILS!
        
        // Use accuracy for floating-point numbers
        XCTAssertEqual(1.29, quake.magnitude, accuracy: 0.001)
        
    }
}
