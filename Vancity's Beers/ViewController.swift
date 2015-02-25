//
//  ViewController.swift
//  Vancity's Beers
//
//  Created by Thanh-Châu Pham on 2015-02-17.
//  Copyright (c) 2015 Handsome Chau. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager: CLLocationManager!
    var theTipperAddress = "2066 Kingsway, Vancouver, BC, Canada"
    var geocoder = CLGeocoder()
    var pinRegion: MKCoordinateRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        // Setup the Map View
        mapView.delegate = self
        mapView.showsBuildings = true
        
        // Use the address string to let the Geocoder instance parses as coordinates
        // and places the pin on the map. Also, zooms into the pin.
        geocoder.geocodeAddressString(theTipperAddress, {
            (placemarks: [AnyObject]!, error: NSError!) -> Void in
            if var placemark = placemarks?[0] as? CLPlacemark
            {
                // Add the pin to the map
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                // Get the coordinates from the pin
                self.pinRegion = MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                self.mapView.setRegion(self.pinRegion, animated: true)
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        println("Authorization status changed to \(status.rawValue)")
        switch status {
            case .Authorized, .AuthorizedWhenInUse:
                manager.startUpdatingLocation()
                mapView.showsUserLocation = true
            default:
                manager.stopUpdatingLocation()
                mapView.showsUserLocation = false
        }
    }
    
    @IBAction func myLocationButtonPressed(sender: AnyObject) {
        // Set the current location's coordinate
        var currentLocation = MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        mapView.setRegion(currentLocation, animated: true)
    }
    
    @IBAction func pinButtonPressed(sender: AnyObject) {
        mapView.setRegion(pinRegion, animated: true)
    }
    
    @IBAction func mapTypeButtonPressed(sender: AnyObject) {
        if mapView.mapType == MKMapType.Standard
        {
            mapView.mapType = MKMapType.Satellite
        }
        else if mapView.mapType == MKMapType.Satellite
        {
            mapView.mapType = MKMapType.Hybrid
        }
        else if mapView.mapType == MKMapType.Hybrid
        {
            mapView.mapType = MKMapType.Standard
        }
    }
    
    /*
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject])
    {
        myLocations.append(locations[0] as CLLocation)
        
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.08, 0.08))
        mapView.setRegion(newRegion, animated: false)
        
        if (myLocations.count > 1)
        {
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        if overlay is MKPolyline
        {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.redColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    */
}