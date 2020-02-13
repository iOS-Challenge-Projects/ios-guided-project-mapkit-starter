//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

// https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=2014-01-01&endtime=2014-01-02


class EarthquakesViewController: UIViewController {
	
    var quakeFetcher = QuakeFetcher()
    
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                print("Error fetching quakes: \(error)")
                return
            }
            
            guard let quakes = quakes else { return }
            
            // TODO: Update the UI
            print("Quakes: \(quakes.count)")

            // Setup MapKit View
            DispatchQueue.main.async {
                self.mapView.addAnnotations(quakes)
                 
            }
        }
	}
}
