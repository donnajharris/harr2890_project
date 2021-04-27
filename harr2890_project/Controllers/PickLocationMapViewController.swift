//
//  PickLocationMapViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-26.
//

import UIKit
import MapKit

class PickLocationMapViewController : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewToAdd : MKMapView!
    
    private let locationManager = CLLocationManager() // needed to get the phone's location
    private var isInitiallyZoomedToUserLocation: Bool = false

    private var chosenLocation : CLLocationCoordinate2D?
        
    func getChosenLocation() -> CLLocationCoordinate2D? {
        return chosenLocation
    }
    
    
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
            self.mapViewToAdd.showsUserLocation = true
                        
            updateMapByCurrentLocation()
            
            
            // Reference: https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(userChosenLocation(gesture:)))
            mapViewToAdd.addGestureRecognizer(longGesture)
           
        }
    } // viewDidLoad
    
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
            mapViewToAdd.setRegion(region, animated: true)
        }
        
    } //updateMapByCurrentLocation

    
    
    @objc func userChosenLocation(gesture: UIGestureRecognizer) {
        
        let touchPoint = gesture.location(in: mapViewToAdd)
        let locationCoordinates = mapViewToAdd.convert(touchPoint, toCoordinateFrom: mapViewToAdd)


        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = locationCoordinates
        newAnnotation.title = "Location to Add"

        // in case there is something from before ... we only want the latest
        mapViewToAdd.removeAnnotations(mapViewToAdd.annotations)

        mapViewToAdd.addAnnotation(newAnnotation)
        
        // want to be able to isolate those coordinates for storage
        chosenLocation = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(newAnnotation.coordinate.latitude),
            longitude: CLLocationDegrees(newAnnotation.coordinate.longitude)
        )

    } // userChosenLocation

}
