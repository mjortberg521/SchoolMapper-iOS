import Foundation
import MapKit

class secondFloorViewController: UIViewController {
    
    //add the secondFloorMapView from the container's child
    @IBOutlet weak var secondFloorMapView: MKMapView!
    
    var school = School(filename: "GBS")
    
    var distance = Int()
    var secondFloorPoints = [String]()
    var firstFloorPoints = [String]()
    
    var movement = String()
    
    /*
    override func viewWillDisappear(_ animated : Bool) { //triggered when user begins swipe pan left gesture
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("MOVING BACKWARD")
            
            for overlayToRemove in secondFloorMapView.overlays {
                if type(of: overlayToRemove) == MKPolyline.self {
                    secondFloorMapView.remove(overlayToRemove)
                }
            }
        }
    }
 */
    
    class CustomPin : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String) {
            self.coordinate = coordinate
            self.title = title
            
            super.init()
        }
    }
    
    override func viewDidLoad() {
        secondFloorMapView.showsCompass = true
        //navigationItem.title = routeName
        print("secondFloorPoints")
        print(secondFloorPoints)
        secondFloorMapView.delegate = self
        
        let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let overlay = SchoolMapOverlay(school: school)
        secondFloorMapView.add(overlay)
        
        if secondFloorPoints.isEmpty == false  {
            //get coordinates from the array of points
            let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let endPoint = coords[coords.count-1] //get the last coord
            let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
            secondFloorMapView.region = region
            
            let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
            secondFloorMapView.add(myPolyline)
            
            //lastCoordName is recieved from the previous view controller - we don't have the graph in this vc and can't use node.name
            let pin = CustomPin(coordinate: endPoint, title: "")
            secondFloorMapView.addAnnotation(pin)
            secondFloorMapView.selectAnnotation(pin, animated: true)
        }
        
        else if secondFloorPoints.isEmpty == true {
            let center = school.midCoordinate
            let region = MKCoordinateRegionMake(center, span)
            secondFloorMapView.region = region
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along
        var DestViewController = segue.destination as! StepsViewController
        DestViewController.distanceInFeet = distance
        
    }
    */
    
    // enforce minimum zoom level
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        if self.secondFloorMapView.camera.altitude > 1350.00 && !modifyingMap {
            modifyingMap = true
            print(modifyingMap)
            //switch to max altitude and center back on endpoint
            // prevents strange infinite loop case
            self.secondFloorMapView.camera.altitude = 1350.00 as? CLLocationDistance ?? CLLocationDistance()
            let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
            let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
            
            if secondFloorPoints.isEmpty == false {
                let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
                let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
                
                let endPoint = coords[coords.count-1] //get the last coord
                let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
                secondFloorMapView.region = region
            }
                
            else if secondFloorPoints.isEmpty == true { //if the array is empty, center the map on the school center
                
                let midPoint = school.midCoordinate
                let region = MKCoordinateRegionMake(midPoint, span) //center the view on the endpoint lat/long
                secondFloorMapView.region = region
            }
            
            modifyingMap = false
        }
    }
    
    func addAnnotations() {
        //guard let attractions = Park.plist("MagicMountainAttractions") as? [[String : String]] else { return }
        
        if movement == "second" {
            let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the last coord
            let type = annotationType(rawValue: "destination")
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            secondFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_downstairs" {
            let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the stair coordinate -- the last coord in second floor points
            let type = annotationType(rawValue: "moving_downstairs")
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            secondFloorMapView.addAnnotation(annotation)
        }
        
        else if movement == "moving_upstairs" {
            let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let coordinate = coords[coords.count-1] //get the second floor destination coordinate -- the last coord in second floor points
            let type = annotationType(rawValue: "destination")
            
            let annotation = Annotations(coordinate: coordinate, type: type!)
            secondFloorMapView.addAnnotation(annotation)
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
}

//MKMapViewDelegate

extension secondFloorViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SchoolMapOverlay {
            return SchoolMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "GBSF2"))
        } else if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor(red:0.2, green:0.48, blue:1.00, alpha:1.0)
            lineView.lineWidth = 10.0
            return lineView
        }
        return MKOverlayRenderer()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        /*
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        
        return pin
        */
        
        let annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
        annotationView.canShowCallout = true
        return annotationView
    }
}
