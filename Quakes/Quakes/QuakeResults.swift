//
//  QuakeResults.swift
//  Quakes
//
//  Created by Paul Solt on 4/9/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

struct QuakeResults: Decodable {
    enum CodingKeys: String, CodingKey {
        case quakes = "features"
    }
    
    let quakes: [Quake]
}
