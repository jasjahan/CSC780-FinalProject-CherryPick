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
    
    //getting the user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            setup()
        }
    }
    
    
    // creating some random fruits around the user using timer & map location
    func setup(){
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true){
            (timer) in if let center = self.manager.location?.coordinate{
                var centerCoordinate = center
                centerCoordinate.latitude = centerCoordinate.latitude +
                (Double.random(in: 0...200) - 100.0)/40000.0
                centerCoordinate.longitude = centerCoordinate.longitude +
                (Double.random(in: 0...200) - 100.0)/40000.0
                
                if let randomFruits = self.fruit.randomElement(){
                    let location = FruitLocation(coord: centerCoordinate, fruit: randomFruits)
                    self.mapView.addAnnotation(location)
                }
                
            }
        }
        
    }
    
    // creating user with user information
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
    
    // picking fruits and limit the location where user won't be able to pick any fruits
    //using FruitLocation CLLocationCoordinate2D class
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation{
            
        }else{
            if let center = manager.location?.coordinate{
                if let fruitCenter = view.annotation?.coordinate{
                    let region = MKCoordinateRegion(center: fruitCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated:false)
                    if let fruitLocation = view.annotation as? FruitLocation{
                        
                        if let fruitname = fruitLocation.fruit.name{
                            
                            if mapView.visibleMapRect.contains(MKMapPoint(center)){
                                fruitLocation.fruit.picked = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                
                                let aleartVC = UIAlertController(title: "Congrats!", message: "You cought a \(fruitname)", preferredStyle:.alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                aleartVC.addAction(okAction)
                                present(aleartVC, animated: true, completion: nil)
                                
                            } else{
                                let aleartVC = UIAlertController(title: "Oh!", message: "You are too far away to pick \(fruitname)!", preferredStyle:.alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                aleartVC.addAction(okAction)
                                present(aleartVC, animated: true, completion: nil)
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    
    //location update using CLLocationManager
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
    
    //getting the precise location of the user with a button so that when playing game
    //if the fruit is toofar away user can easily move to the cutrrent location
    
    @IBAction func zoomOut(_ sender: Any) {
        if let center = manager.location?.coordinate{
            let region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: 100,
                                            longitudinalMeters: 100)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    //screen navigation from mapView to fruitView so that user
    //can easily check anytime how many fruits are left to be picked
    
    @IBAction func centerTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "ToFruitViewController", sender: nil)
    }
}
