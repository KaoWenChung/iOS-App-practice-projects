//
//  MapViewController.swift
//  MapKitDirection
//
//  Created by Simon Ng on 6/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var restaurant:Restaurant!
    var currentPlacemark: CLPlacemark?
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoutes: MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.isHidden = true
        
        segmentedControl.addTarget(self, action: #selector(showDirection), for: .valueChanged)
        
        // Request user for authorization to use location services
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        
        mapView.showsUserLocation = true
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                self.currentPlacemark = placemark
                
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
        mapView.delegate = self
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView: MKAnnotationView?
        
        if #available(iOS 11.0, *) {
            var markerAnnotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if markerAnnotationView == nil {
                markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerAnnotationView?.canShowCallout = true
            }
            
            markerAnnotationView?.glyphText = "😋"
            markerAnnotationView?.markerTintColor = UIColor.orange
        
            annotationView = markerAnnotationView
            
        } else {
            
            var pinAnnotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView?.canShowCallout = true
                pinAnnotationView?.pinTintColor = UIColor.orange
            }
            
            annotationView = pinAnnotationView
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        leftIconView.image = UIImage(named: restaurant.image)
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
//        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    @IBAction func showDirection(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: currentTransportType = .automobile
        case 1: currentTransportType = .walking
        default: break
        }
        
        segmentedControl.isHidden = false
        
        guard let currentPlacemark = currentPlacemark else {
            return
        }
        let directionRequest = MKDirections.Request()
        
        // Set original location
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                return
            }
            let route = routeResponse.routes[0]
            self.currentRoutes = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        performSegue(withIdentifier: "showSteps", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use segue.destinationViewController to get new viewController
        // Sent selected objects to the new viewController
        if segue.identifier == "showSteps" {
            let routeTableViewController = segue.destination.children[0] as! RouteTableViewController
            if let steps = currentRoutes?.steps {
                routeTableViewController.routeSteps = steps
            }
        }
    }
    
}
