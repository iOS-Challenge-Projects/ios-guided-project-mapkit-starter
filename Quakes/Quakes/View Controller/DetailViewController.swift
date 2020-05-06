//
//  DetailViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/6/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coodinatesLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    var selectedQuake: Quake? {
        didSet{
            setupLabels()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
    
    private lazy var latLonFormatter: NumberFormatter = {
         let result = NumberFormatter()
         result.numberStyle = .decimal
         result.minimumIntegerDigits = 1
         result.minimumFractionDigits = 2
         result.maximumFractionDigits = 2
         return result
     }()
    
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        
    }
    
    //MARK: - Setup View
    func setupLabels(){
        if let quake = selectedQuake{
            
            guard let lat = latLonFormatter.string(from: quake.latitude as NSNumber), let lon = latLonFormatter.string(from: quake.longitude as NSNumber) else { return }
            
            let date = dateFormatter.string(from: quake.time)
            
            placeLabel.text = quake.place
            
            dateLabel.text = " Date: \(date)"
            
            coodinatesLabel.text = " Lat: \(lat) Lon: \(lon)"
            
            if let magnitude = quake.magnitude {
                magnitudeLabel.text = " Magnitude: \(magnitude)"
            }else{
                magnitudeLabel.text = " Magnitude: N/A"
            }
            
            locateOnMap(for: quake.coordinate)
        }
    }
    
    
    func locateOnMap(for location: CLLocationCoordinate2D) {
        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        
        let coordinateRegion = MKCoordinateRegion(center: location, span: coordinateSpan)
        
//        lookUpCurrentLocation { locationName in
//            DispatchQueue.main.async {
//                self.navigationItem.title = locationName?.locality
//            }
            
            self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
}

    //MARK: - MKMapViewDelegate
extension DetailViewController:  MKMapViewDelegate {
    
}
