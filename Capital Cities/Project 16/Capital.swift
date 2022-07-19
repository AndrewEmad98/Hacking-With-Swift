//
//  Capital.swift
//  Project 16
//
//  Created by Andrew Emad on 19/07/2022.
//

import UIKit
import MapKit

class Capital: NSObject,MKAnnotation{

    var title : String?
    var coordinate: CLLocationCoordinate2D
    var info : String
    
    init(title : String,coordinate : CLLocationCoordinate2D,info : String){
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
