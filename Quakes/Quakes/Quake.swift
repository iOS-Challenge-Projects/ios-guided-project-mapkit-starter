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
	
	// place
	// time
	// lat, long

	let magnitude: Double
	let place: String
	let time: Date
	let latitude: Double
	let longitude: Double
	
	
	enum QuakeCodingKeys: String, CodingKey {
		case magnitude = "mag"
		case properties
		case place
		case time
		case latitude
		case longitude
		case geometry
		case coordinates
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
		let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
		let geometry = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .geometry)
		var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
		
		self.magnitude = try properties.decode(Double.self, forKey: .magnitude)
		self.place = try properties.decode(String.self, forKey: .place)
		self.time = try properties.decode(Date.self, forKey: .time)
		self.longitude = try coordinates.decode(Double.self)
		self.latitude = try coordinates.decode(Double.self)
		
		super.init()
	}
	
}
