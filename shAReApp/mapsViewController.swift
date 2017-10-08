//
//  mapsViewController.swift
//  shAReApp
//
//  Created by Pascal Couturier on 29/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class mapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

        // Zoom in on user location by clicking my location button - https://stackoverflow.com/questions/31040667/zoom-in-on-user-location-swift
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBAction func searchMyLocation(_ sender: Any) {

        
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        
        
        // Static pins on map with location services
        
        let rmitUniversity:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-37.809304, 144.964310)
        
        let stkildaBaths:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-37.865306, 144.972011)
        // Drop a pin
        
        let annotation =  MKPointAnnotation()
        
        annotation.coordinate = rmitUniversity
        annotation.title = "Street of RMIT University"
        annotation.subtitle = "Bring it on"
        mapView.addAnnotation(annotation)
        
        let annotation2 =  MKPointAnnotation()
        
        annotation2.coordinate = stkildaBaths
        annotation2.title = "St Kilda Baths"
        annotation2.subtitle = "Pop by for a workout!"
        mapView.addAnnotation(annotation2)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


