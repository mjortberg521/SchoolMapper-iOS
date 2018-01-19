import UIKit
import MapKit

class SchoolMapOverlay: NSObject, MKOverlay {
    
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(school: School) {
        boundingMapRect = school.overlayBoundingMapRect
        coordinate = school.midCoordinate
    }
}

