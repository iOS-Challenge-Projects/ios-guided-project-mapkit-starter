//
//  EarthquakesViewController.swift
//  iOS8-Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
		
	var quakeFetcher = QuakeFetcher()
	
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.delegate = self
		mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
		
		fetchQuakes()
	}
	
	private func fetchQuakes() {
		quakeFetcher.fetchQuakes { (quakes, error) in
			
			if let error = error {
				print("Error: \(error)")
			}
			
			if let quakes = quakes {
				//print("Quakes: \(quakes)")
				print("Quakes: \(quakes.count)")
				DispatchQueue.main.async {
					
					// Show a Region of Interest (ROI) -> Zoom map to location
					// Show the first quake, the biggest quake
					// Sort our earthquakes on the server request or locally
					// Customize the popup (register Cell)
					// Custom pin color (severity)
					// Decode bug: mag
					
					
					self.mapView.addAnnotations(quakes)
					
					guard let largestQuake = quakes.first else { return }
					
					// Zoom to the earthquake
					let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
					let region = MKCoordinateRegion(center: largestQuake.coordinate, span: coordinateSpan)
					self.mapView.setRegion(region, animated: true)
				}
			}
		}
	}
}

extension EarthquakesViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		guard let quake = annotation as? Quake else {
			fatalError("Only Quake objects are supported in demo")
		}
		
		guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView") as? MKMarkerAnnotationView else {
			fatalError("Missing a registered map annotation view")
		}
		
		annotationView.glyphImage = UIImage(named: "QuakeIcon")
		
		if quake.magnitude >= 5 {
			annotationView.markerTintColor = .red
		} else if quake.magnitude >= 3 && quake.magnitude < 5 {
			annotationView.markerTintColor = .orange
		} else {
			annotationView.markerTintColor = .yellow
		}
		
		annotationView.canShowCallout = true
		let detailView = QuakeDetailView()
		detailView.quake = quake
		annotationView.detailCalloutAccessoryView = detailView
		
		return annotationView
	}
}
