import UIKit
import MapKit

class mapViewController: UIViewController {
    
    //@IBOutlet weak var mapView: MKMapView!

    //these are the stacked views
    @IBOutlet weak var firstFloorView: UIView!
    @IBOutlet weak var secondFloorView: UIView!
    
    
    
    /*
    
    private lazy var firstFloorViewController: firstFloorViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "firstFloorViewController") as! firstFloorViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var secondFloorViewController: secondFloorViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "secondFloorViewController") as! secondFloorViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    */
    
    /*
    lazy var firstVC: firstFloorViewController = {
        let vc = firstFloorViewController()
        self.addAsChildVC(childVC: vc)
        return vc
    }()
    
    lazy var secondVC: secondFloorViewController = {
        let vc = secondFloorViewController()
        self.addAsChildVC(childVC: vc)
        return vc
    }()
    
    func addAsChildVC(childVC: UIViewController) {
        addChildViewController(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = self.view.frame
        childVC.didMove(toParentViewController: self)
    }
 */

    var school = School(filename: "GBS")
    
    //vars from previous viewcontroller
    var routeName = String()
    var distance = Int()
    
    var firstFloorPoints = [String]() //working
    var secondFloorPoints = [String]()
    
    var movement = String()
    
    @IBOutlet weak var stepsButton: UIBarButtonItem!
    
    @IBAction func stepsButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueSteps", sender: self)
        
    }
    
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex
        {
         case 0:
            firstFloorView.isHidden = false
            secondFloorView.isHidden = true
         case 1:
            firstFloorView.isHidden = true
            secondFloorView.isHidden = false
        default:
          break;
        }
    }
    
    //move to the container children
    /*
    override func viewWillDisappear(_ animated : Bool) { //triggered when user begins swipe pan left gesture
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            print("MOVING BACKWARD")
            
            for overlayToRemove in mapView.overlays {
                if type(of: overlayToRemove) == MKPolyline.self {
                    mapView.remove(overlayToRemove)
                }
            }
        }
    }
    */
    
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
    
    override func viewDidLoad() {
        //mapView.showsCompass = true
        //super.viewDidLoad()
        navigationItem.title = routeName
        
        //let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
        //let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        //let overlay = SchoolMapOverlay(school: school)
        //mapView.add(overlay)
        
        //get coordinates from the array of points
        //let cgPoints = points.map { CGPointFromString($0) }
        //let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        //let endPoint = coords[coords.count-1] //get the last coord
        //let region = MKCoordinateRegionMake(endPoint, span) //center the view on the endpoint lat/long
        //mapView.region = region
        
        //let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
        //mapView.add(myPolyline)
        
        //lastCoordName is recieved from the previous view controller - we don't have the graph in this vc and can't use node.name
        //let pin = CustomPin(coordinate: endPoint, title: lastCoordName)//uses lastCoordName from previous vc (insead of looking up name of last node given coord)
        //mapView.addAnnotation(pin)
        //mapView.selectAnnotation(pin, animated: true)
        firstFloorView.isHidden = false
        secondFloorView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along

        if segue.identifier == "firstFloorContainerView" {
            let childViewControllerFirst = segue.destination as! firstFloorViewController
            childViewControllerFirst.firstFloorPoints = firstFloorPoints
            childViewControllerFirst.secondFloorPoints = secondFloorPoints
            
            childViewControllerFirst.distance = distance
            childViewControllerFirst.movement = movement
        }
        
        else if segue.identifier == "secondFloorContainerView" {
            let childViewControllerSecond = segue.destination as! secondFloorViewController
            childViewControllerSecond.secondFloorPoints = secondFloorPoints
            childViewControllerSecond.firstFloorPoints = firstFloorPoints
            
            childViewControllerSecond.distance = distance
            childViewControllerSecond.movement = movement
        }
        
        else if segue.identifier == "segueSteps" {
            let DestViewControllerSteps = segue.destination as! StepsViewController
            DestViewControllerSteps.distanceInFeet = distance
        }

    }

    
    // enforce minimum zoom level
    
    /*
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        if self.mapView.camera.altitude > 1800.00 && !modifyingMap {
            modifyingMap = true
            print(modifyingMap)
            // prevents strange infinite loop case
            self.mapView.camera.altitude = 1800.00 as? CLLocationDistance ?? CLLocationDistance()
            modifyingMap = false            
        }
    }
    */
}

//MKMapViewDelegate

/*
extension mapViewController: MKMapViewDelegate {
    
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        pin.canShowCallout = true
        
        return pin
    }
}
 */
