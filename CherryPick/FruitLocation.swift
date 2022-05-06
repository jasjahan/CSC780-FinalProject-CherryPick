//
//  FruitLocation.swift
//  CherryPick
//
//  Created by Jasmine Jahan on 5/6/22.
//

import UIKit
import MapKit

class FruitLocation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var fruit : Fruit
    
    init(coord : CLLocationCoordinate2D, fruit: Fruit) {
        self.coordinate = coord
        self.fruit = fruit
    }
    

}
