//
//  HazardAnnotation.swift
//  FlareSDKSample
//
//  Created by Phoenix Innovate on 23/09/24.
//

import Foundation
import MapKit

class HazardAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, image: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
    }
}

