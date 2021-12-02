//
//  MapViewController.swift
//  Assignment2
//
//  Created by qta on 9/10/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var addressmap : String = ""
    var mapDistance : Double = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true
        
        if addressmap == "" {
            let sydneyCenter = CLLocation(latitude: -33.8688, longitude: 151.2093)
            let region = MKCoordinateRegion (center: sydneyCenter.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: mapDistance)
            map.setCameraZoomRange(zoomRange, animated: true)
        }
        else {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressmap, completionHandler: {
                placemarks, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    let annotation = MKPointAnnotation()
                    annotation.title = self.addressmap
                    
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        self.map.showAnnotations([annotation], animated: true)
                        self.map.selectAnnotation(annotation, animated: true)
                    }
                }
            })
            map.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
