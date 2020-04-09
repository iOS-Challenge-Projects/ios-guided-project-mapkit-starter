//
//  Quake.swift
//  Quakes
//
//  Created by Paul Solt on 4/9/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

// Conforming to MKAnnotation requires a NSObject subclass

class Quake: NSObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case time
        case place
        case latitude
        case longitude
        case properties
        case geometry
        case coordinates
    }
    
    let magnitude: Double?
    let time: Date
    let place: String
    let latitude: Double
    let longitude: Double
    
    required init(from decoder: Decoder) throws {
        // Containers to pull out data
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        // Extract our properties
        
        // use try? or decodeIfPresent so we don't throw an error and fail to decode
        self.magnitude = try properties.decodeIfPresent(Double.self, forKey: .magnitude)
        self.time = try properties.decode(Date.self, forKey: .time)
        self.place = try properties.decode(String.self, forKey: .place)

        // Longitude is before latitude in the array
        self.longitude = try coordinates.decode(Double.self)
        self.latitude = try coordinates.decode(Double.self)
        
        super.init()
    }
}
