//
//  Quake.swift
//  Quakes
//
//  Created by Paul Solt on 3/12/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

class Quake: NSObject, Decodable {
    let magnitude: Double
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case properties
        case place
        case time
        case geometry
        case coordinates
    }
    
    required init(from decoder: Decoder) throws {
        // Containers
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        let geometry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        // Attributes
        self.magnitude = try properties.decode(Double.self, forKey: .magnitude)
        self.place = try properties.decode(String.self, forKey: .place)
        self.time = try properties.decode(Date.self, forKey: .time)

        // Potentially if our depth data was first, we might need to
        // "throw" away that value if we don't want to parse
        //        _ = try coordinates.decode(Double.self) // ignore depth
        self.longitude = try coordinates.decode(Double.self)
        self.latitude = try coordinates.decode(Double.self)
        
        super.init()
    }
}
