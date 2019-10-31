//
//  Quake.swift
//  Quakes
//
//  Created by Paul Solt on 10/31/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import Foundation

// MKAnnotation requires we subclass NSObject
// Allows us to show data on the a map

class Quake: NSObject, Decodable {
	
	// mag
	// place
	// time
	// lat, long
	
	let magnitude: Double
	
	enum QuakeCodingKeys: String, CodingKey {
		case magnitude = "mag"
		case properties
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
		let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
		
		
		self.magnitude = try properties.decode(Double.self, forKey: .magnitude)
		
		super.init()
	}
	
}
