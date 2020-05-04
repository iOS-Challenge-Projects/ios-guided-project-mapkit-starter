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
    
    //MARK: - Properties
    var quakeFetcher = QuakeFetcher()
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    //MARK: - Outlets
    
    // NOTE: You need to import MapKit to link to MKMapView
    @IBOutlet var mapView: MKMapView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Create a reusable cell
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
        
        
        fetchQuakes()
    }
    
    //MARK: - Setup Methods
    
    func fetchQuakes()  {
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error{
                print("Error fetching quakes: \(error)")
                return
            }
            guard let quakes = quakes else { return }
            
            DispatchQueue.main.async {
                //This create the pins on the map
                self.mapView.addAnnotations(quakes)
                
                self.currentLocation()
                
            }
        }
    }
    
    func currentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        
        
        guard let currentLocation = self.locationManager.location?.coordinate else {
            print("Current location N/A")
            return }
        
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, span: coordinateSpan)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        currentLocation()
    }
}
//MARK: - MKMapViewDelegate

extension EarthquakesViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Get quake
        guard let quake = annotation as? Quake else {
            fatalError("Only supporting quakes")
        }
        //Get anotationview
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: quake) as? MKMarkerAnnotationView else {
            fatalError("Missing register map anotation")
        }
        
        //Customized base on data
        annotationView.glyphImage = UIImage(named: "QuakeIcon")
        
        //Change the color of the marker base on the severaty of the quake
        if let magnitude = quake.magnitude {
            if magnitude >= 5 {
                annotationView.markerTintColor = .red
            } else if magnitude >= 3 && magnitude < 5 {
                annotationView.markerTintColor = .orange
            }else{
                annotationView.markerTintColor = .yellow
            }
        }else{
            //If there is no magnitude set to white
            annotationView.markerTintColor = .white
        }
        
        //New view when we tap on the pin showing details
        annotationView.canShowCallout = true
        let detailView = QuakeDetailView()
        detailView.quake = quake
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
}
