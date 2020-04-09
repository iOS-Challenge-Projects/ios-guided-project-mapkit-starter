//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
		
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
	
    var quakeFetcher = QuakeFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
        
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                print ("Error fetching quakes: \(error)")
                return
            }
            
            guard let quakes = quakes else { return }

            DispatchQueue.main.async {
                print("Quakes: \(quakes.count)")
                
                self.mapView.addAnnotations(quakes)
                
                guard let quake = quakes.first else { return }
                
                let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                let region = MKCoordinateRegion(center: quake.coordinate, span: coordinateSpan)
                
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
}

extension EarthquakesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Quake
        guard let quake = annotation as? Quake else {
            fatalError("Currently only supporting Quakes")
        }
        
        // Annotation view
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: quake) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered map annotation")
        }
        
        // Customize based on data
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        
        if let magnitude = quake.magnitude {
            if magnitude >= 5 {
                annotationView.markerTintColor = .red
            } else if magnitude >= 3 && magnitude < 5 {
                annotationView.markerTintColor = .orange
            } else { // <3
                annotationView.markerTintColor = .yellow
            }
        } else {
            annotationView.markerTintColor = .white
        }
        
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
