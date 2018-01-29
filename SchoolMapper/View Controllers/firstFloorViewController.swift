import Foundation
import MapKit

class firstFloorViewController: UIViewController {
        
    @IBOutlet weak var firstFloorMapView: MKMapView!
    
    var school = School(filename: "GBS")
    
    var distance = Int()
    var firstFloorPoints = [String]() //all the coordinates are being passed along okay.
    var secondFloorPoints = [String]()
    
    var movement = String()
    
    /*
    class CustomPin : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String) {
            self.coordinate = coordinate
            self.title = title
            
            super.init()
        }
    }
    */
    
    func addAnnotations() {
        
        if movement == "first" {
            print(movement)
            let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the last coord
            let type = annotationType(rawValue: "destination")
            
            print("coordinate")
            print(coordinate)
            print(type)
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            firstFloorMapView.addAnnotation(annotation)
        }
            
            /*
             else if movement == "second" {
             let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
             let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
             
             let coordinate = coords[coords.count-1] //get the last coord
             let type = annotationType(rawValue: "destination")
             
             let annotation = Annotations(coordinate: coordinate, type: type!)
             firstFloorMapView.addAnnotation(annotation) //----------------------- SWITCH THIS TO THE SECONDFLOORVIEWCONTROLLER ASAP_--__-____-__--__--__--__--__-
             }
             */
            
        else if movement == "moving_upstairs" {
            let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the stair coordinate -- the last coord in first floor points
            let type = annotationType(rawValue: "moving_upstairs")
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            firstFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_downstairs" {
            let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the first floor destination coordinate -- the last coord in second floor points
            let type = annotationType(rawValue: "destination")
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            firstFloorMapView.addAnnotation(annotation)
        }
        /*
         for attraction in attractions {
         let coordinate = Park.parseCoord(dict: attraction, fieldName: "location")
         //let title = attraction["name"] ?? ""
         //let typeRawValue = Int(attraction["type"] ?? "0") ?? 0
         let type = AttractionType(rawValue: typeRawValue) ?? .misc
         //let subtitle = attraction["subtitle"] ?? ""
         let annotation = Annotations(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
         mapView.addAnnotation(annotation)
         }
         */
    }
    
    
    override func viewDidLoad() {
        print("firstFloorPoints")
        print(firstFloorPoints)
        firstFloorMapView.showsCompass = true
        //navigationItem.title = routeName
        
        let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let overlay = SchoolMapOverlay(school: school)
        firstFloorMapView.add(overlay)
        
        //get coordinates from the array of points
        let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let endPoint = coords[coords.count-1] //get the last coord
        let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
        firstFloorMapView.region = region
        
        print("coords")
        print(coords)
        //coordinates are working okay
        
        let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        firstFloorMapView.add(myPolyline)
        
        addAnnotations()
        
        //lastCoordName is recieved from the previous view controller - we don't have the graph in this vc and can't use node.name
        
        //let pin = CustomPin(coordinate: endPoint, title: "test")
        //firstFloorMapView.addAnnotation(pin)
        //firstFloorMapView.selectAnnotation(pin, animated: true)
        
        //super.viewDidLoad()
        //firstFloorMapView.delegate = sel
    }

    // enforce minimum zoom level
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        print(modifyingMap)
        
        if self.firstFloorMapView.camera.altitude > 1350.00 && !modifyingMap {
            modifyingMap = true
            print(modifyingMap)
            //switch to max altitude and center back on endpoint
            // prevents strange infinite loop case
            self.firstFloorMapView.camera.altitude = 1350.00 as? CLLocationDistance ?? CLLocationDistance()
            
            //make these class variables, I was in a hurry lol...
            let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
            let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
            
            if firstFloorPoints.isEmpty == false {
                let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
                let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
                
                let endPoint = coords[coords.count-1] //get the last coord
                let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
                firstFloorMapView.region = region
            }
            
            else if firstFloorPoints.isEmpty == true { //if the array is empty, center the map on the school center
                
                let midPoint = school.midCoordinate
                let region = MKCoordinateRegionMake(midPoint, span) //center the view on the endpoint lat/long
                firstFloorMapView.region = region
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
            lineView.lineWidth = 10.0
            return lineView
        }
        return MKOverlayRenderer()
    }

    func mapView(mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /*
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        pin.image = #imageLiteral(resourceName: "gbs-shield")
        
        return pin
        */
        
        let annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationView.canShowCallout = true
        return annotationView
    }
}
