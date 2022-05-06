//
//  MapViewController.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/4/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var count = 0
    var fruit : [Fruit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fruit = getAllFruits()
        
        manager.delegate = self
        
        if manager.authorizationStatus == .authorizedWhenInUse {
            setup()
        } else {
            manager.requestWhenInUseAuthorization()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }
    
    func setup(){
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true){
            (timer) in if let center = self.manager.location?.coordinate{
                var centerCoordinate = center
                centerCoordinate.latitude = centerCoordinate.latitude +
                                            (Double.random(in: 0...200) - 100.0)/50000.0
                centerCoordinate.longitude = centerCoordinate.longitude +
                                            (Double.random(in: 0...200) - 100.0)/50000.0
                
                if let randomFruits = self.fruit.randomElement(){
                    let location = FruitLocation(coord: centerCoordinate, fruit: randomFruits)
                    self.mapView.addAnnotation(location)
                }
                
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation{
            annoView.image = UIImage(named: "squirrel")
        } else{
            if let fruitLocation = annotation as? FruitLocation{
                if let imageName = fruitLocation.fruit.imageName{
                    annoView.image = UIImage(named: imageName)
                }
            }
        }
        var frame = annoView.frame
        frame.size.height = 50.0
        frame.size.width = 50.0
        annoView.frame = frame
        return annoView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if count < 3 {
            if let center = manager.location?.coordinate{
                let region = MKCoordinateRegion(center: center,
                                                latitudinalMeters: 100,
                                                longitudinalMeters: 100)
                mapView.setRegion(region, animated: true)
            }
            count = count + 1
        }else{
            manager.stopUpdatingLocation()
        }
        
    }
    
    @IBAction func zoomOut(_ sender: Any) {
        if let center = manager.location?.coordinate{
            let region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: 100,
                                            longitudinalMeters: 100)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func centerTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "ToFruitViewController", sender: nil)
    }
}
