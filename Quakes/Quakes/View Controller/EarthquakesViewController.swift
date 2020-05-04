//
//  SearchTableTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/4/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
    
    //MARK: - Properties
    var quakeFetcher = QuakeFetcher()
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    var quakesArray: [Quake]?
    var selectedQuake: Quake?{
        didSet{
            print("Got it")
        }
    }
    //MARK: - Outlets
    
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
            self.quakesArray = quakes
            //Find the highest magnitud earthquake
//            let maxQuake = quakes.max { (a, b) -> Bool in
//                return Int(a.magnitude!) < Int(b.magnitude!)
//            }
//            print("maxQuake\(maxQuake?.place)")
//            print("maxQuake\(maxQuake?.magnitude)")
//            print("Ammount of quakes: \(quakes.count)")
            
            DispatchQueue.main.async {
                //Create annotations
                self.mapView.addAnnotations(quakes)
                
                //Show the user current location to start with
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
        
        //FIXME: Check if user allow location if not hotlink to settings
        guard let currentLocation = self.locationManager.location?.coordinate else {
            print("Current location N/A")
            return }
        
        lookUpCurrentLocation { locationName in
            DispatchQueue.main.async {
                self.navigationItem.title = locationName?.locality
            }
        }
        
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, span: coordinateSpan)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                    -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                 // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        currentLocation()
    }
    
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue"{
            
            guard let searchVC = segue.destination as? SearchTableViewController else {
                print("Cannot downcast SearchVC")
                return
            }
        
            searchVC.quakesArray = self.quakesArray ?? []
        }
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
