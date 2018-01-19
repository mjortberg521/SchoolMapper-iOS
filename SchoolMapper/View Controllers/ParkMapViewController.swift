import UIKit
import MapKit

class mapviewcontroller: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var park = Park(filename: "GBS")
    
    //vars from previous viewcontroller
    var routeName = String()
    var points = [String]() //array of string coordinates from previous viewcontroller
    var distance = Int()
    var lastCoordName = String()

    @IBOutlet weak var stepsButton: UIBarButtonItem!
    
    @IBAction func stepsButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueSteps", sender: self)

    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("MOVING BACKWARD")
            //let overlays = mapView.overlays
            //mapView.removeOverlays(overlays)
            
            
            for overlayToRemove in mapView.overlays {
                if type(of: overlayToRemove) == MKPolyline.self {
                    mapView.remove(overlayToRemove)
                }
            }
        }
    }

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
        mapView.showsCompass = true
        navigationItem.title = routeName

        let latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let overlay = ParkMapOverlay(park: park)
        mapView.add(overlay)
        
        //get coordinates from the array of points
        let cgPoints = points.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let endPoint = coords[coords.count-1] //get the last coord
        let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
        mapView.region = region
        
        let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        mapView.add(myPolyline)
        
        let pin = CustomPin(coordinate: endPoint, title: lastCoordName)//uses lastCoordName from previous vc (insead of looking up name of last node given coord)
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
  }
}

//MKMapViewDelegate

extension mapviewcontroller: MKMapViewDelegate {
    
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is ParkMapOverlay {
      return ParkMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "GBS"))
    } else if overlay is MKPolyline {
      let lineView = MKPolylineRenderer(overlay: overlay)
      lineView.strokeColor = UIColor(red:0.2, green:0.48, blue:1.00, alpha:1.0)
      lineView.lineWidth = 10.0
      return lineView
    }
    return MKOverlayRenderer()
    }
  
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        //pin.animatesDrop = true
        //pin.pinTintColor = UIColor.red
        pin.canShowCallout = true

        return pin
    }
  }
