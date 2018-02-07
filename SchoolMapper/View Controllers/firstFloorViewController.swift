import Foundation
import MapKit

class firstFloorViewController: UIViewController {
        
    @IBOutlet weak var firstFloorMapView: MKMapView!
    
    var school = School(filename: "GBSF1")
    
    var distance = Int()
    var firstFloorPoints = [String]() //all the coordinates are being passed along
    var secondFloorPoints = [String]()
    
    var movement = String()
    var destinationName = String()
    
    func addAnnotations() {
        let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let coordinate = coords[coords.count-1] //get the last coord
        
        if movement == "first" {
            let type = annotationType(rawValue: "destination") ?? .destination //this is the same rawValue as Annotations.swift enum case
            
            let annotation = Annotations(coordinate: coordinate, title: destinationName, type: type)
            firstFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_upstairs" {
            let type = annotationType(rawValue: "moving_upstairs") ?? .moving_upstairs //this is the same rawValue as Annotations.swift enum case
            
            let annotation = Annotations(coordinate: coordinate, title: destinationName, type: type)
            firstFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_downstairs" {
            let type = annotationType(rawValue: "destination") ?? .destination //this is the same rawValue as Annotations.swift enum case
            
            let annotation = Annotations(coordinate: coordinate, title: destinationName, type: type)
            firstFloorMapView.addAnnotation(annotation)
        }
    }
    
    func deg2rad(deg:Double) -> Double {
        return deg * 3.1415 / 180
    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / 3.1415
    }
    
    //function to find the geometric center of a set of points
    func centerCoordinate(forCoordinates coordinateArray: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
       
        if coordinateArray.count == 1 { //handle the case where there is only one point-without this the span is invalid
            return coordinateArray[0]
        }
        
        else {
            var x: Double = 0
            var y: Double = 0
            var z: Double = 0
            for coordinateValue in coordinateArray {
                let lat: Double = deg2rad(deg: coordinateValue.latitude)
                let lon: Double = deg2rad(deg: coordinateValue.longitude)
                
                x += cos(lat) * cos(lon)
                y += cos(lat) * sin(lon)
                z += sin(lat)
            }
            x = x / Double(coordinateArray.count)
            y = y / Double(coordinateArray.count)
            z = z / Double(coordinateArray.count)
            
            let resultLon: Double = atan2(y, x)
            let resultHyp: Double = sqrt(x * x + y * y)
            let resultLat: Double = atan2(z, resultHyp)
            let result: CLLocationCoordinate2D = CLLocationCoordinate2DMake(rad2deg(rad: resultLat), rad2deg(rad: resultLon))
            
            return result
        }
    }
    
    override func viewDidLoad() {
        firstFloorMapView.showsCompass = true
        
        let overlay = SchoolMapOverlay(school: school)
        firstFloorMapView.add(overlay)
        
        //get coordinates from the array of points
        if firstFloorPoints.isEmpty == false {
            let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }

            var latDelta = Double()
            latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude)
            latDelta+=latDelta/3 //add a slight buffer to allow viewing of space around start and end point
            
            var lonDelta = Double()
            lonDelta = (coords[(coords.count)-1]).longitude-(coords[0]).longitude
            lonDelta+=lonDelta/3
            
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            let midPoint = centerCoordinate(forCoordinates: coords)
            let region = MKCoordinateRegionMake(midPoint, span) //center the view on the middle lat/long
            
            firstFloorMapView.setRegion(region, animated: true)
            //self.firstFloorMapView.camera.altitude = 890.00 as? CLLocationDistance ?? CLLocationDistance()
            
            let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
            firstFloorMapView.add(myPolyline)
            
            addAnnotations()
        }
        
        else if firstFloorPoints.isEmpty == true {
            let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
            let lonDelta = school.overlayTopLeftCoordinate.longitude - school.overlayBottomRightCoordinate.longitude
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            let center = school.midCoordinate
            let region = MKCoordinateRegionMake(center, span)
            
            firstFloorMapView.setRegion(region, animated: true)
            //self.firstFloorMapView.camera.altitude = 890.00 as? CLLocationDistance ?? CLLocationDistance()
        }
    }

    // enforce minimum zoom level
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        if self.firstFloorMapView.camera.altitude > 1100.00 && !modifyingMap {
            modifyingMap = true
            //prevent infinite loop

            self.firstFloorMapView.camera.altitude = 1099.00 as? CLLocationDistance ?? CLLocationDistance()
            
            let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
            let lonDelta = school.overlayTopLeftCoordinate.longitude - school.overlayBottomRightCoordinate.longitude
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            if firstFloorPoints.isEmpty == false {
                let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
                let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
                
                let midPoint = centerCoordinate(forCoordinates: coords) //get the middle route coord
                let region = MKCoordinateRegionMake(midPoint, span) //center the view on the middle lat/long
                
                firstFloorMapView.setRegion(region, animated: true) //setting the correct region
            }
            
            else if firstFloorPoints.isEmpty == true { //if the array is empty, center the map on the school center
                let center = school.midCoordinate
                let region = MKCoordinateRegionMake(center, span)
                
                firstFloorMapView.setRegion(region, animated: true)
            }
            modifyingMap = false            
        }
    }
}

//MKMapViewDelegate
extension firstFloorViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SchoolMapOverlay {
            return SchoolMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "GBSF1"))
        } else if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor(red:0.2, green:0.48, blue:1.00, alpha:1.0)
            lineView.lineWidth = 8.5
            return lineView
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
 
        let annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = false
        return annotationView
    }
}
