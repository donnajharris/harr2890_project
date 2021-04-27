//
//  MapViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-26.
//

import UIKit
import MapKit


// FIRST..... Setup permissions for location in Info.plist  ....
// - Add: NSLocationAlwaysAndWhenInUseUsageDescription (aka "Privacy - Location Always and When In Use Usage Description")
// - Add: NSLocationWhenInUseUsageDescription (aka "Privacy - Location When In Use Usage Description")


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewOnTab: MKMapView!
    
    let locationManager = CLLocationManager() // needed to get the phone's location
    var isInitiallyZoomedToUserLocation: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            
            self.locationManager.distanceFilter = 1000 // in metres
            self.locationManager.startUpdatingLocation()
            
            // The blue dot: "You are here"
            self.mapViewOnTab.showsUserLocation = true
                        
            updateMapByCurrentLocation()
            
            addSampleLocations()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMapByCurrentLocation()
    }
    
    
    // Reference: https://stackoverflow.com/questions/42810109/current-location-in-mapkit
    func updateMapByCurrentLocation() {

        if let sourcelocation = self.locationManager.location?.coordinate {

            let currentLatitude = sourcelocation.latitude
            let currentLongitude = sourcelocation.longitude
            
            let place = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: place, span: span)
            mapViewOnTab.setRegion(region, animated: true)
        } else {
            print("\tUGH!! I dunno!")
        }
        
    } //updateMapByCurrentLocation


    
    func addSampleLocations() {
        // adding locations
        
        let place1 = CLLocationCoordinate2D(latitude: 43.56807194067141, longitude: -80.25863767388105) //Bank

        let annotation = MKPointAnnotation()
        annotation.coordinate = place1
        annotation.title = "Deposit cheques"  // Item Title
        annotation.subtitle = "on Apr. 26"    // Item Date
        mapViewOnTab.addAnnotation(annotation)
        
        
        // REXALL: 43.55735646883398, -80.24852849740334

        let place2 = CLLocationCoordinate2D(latitude: 43.55735646883398, longitude: -80.24852849740334) //Drug store

        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = place2
        annotation2.title = "Pick up prescription"
        annotation2.subtitle = "by Apr. 27"
        mapViewOnTab.addAnnotation(annotation2)
        
    } //addSampleLocations
    
}
