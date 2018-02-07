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
    var destinationName = String()
    
    @IBOutlet weak var stepsButton: UIBarButtonItem!
    
    @IBAction func stepsButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueSteps", sender: self)
        
    }
    
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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

    override func viewDidLoad() {
        navigationItem.title = routeName

        if movement == "first" {
            firstFloorView.isHidden = false
            secondFloorView.isHidden = true
            segmentedControl.selectedSegmentIndex = 0
        }
            
        else if movement == "second" {
            firstFloorView.isHidden = true
            secondFloorView.isHidden = false
            segmentedControl.selectedSegmentIndex = 1
        }
        else if movement == "moving_upstairs" {
            firstFloorView.isHidden = false
            secondFloorView.isHidden = true
            segmentedControl.selectedSegmentIndex = 0
        }
        
        else if movement == "moving_downstairs" {
            firstFloorView.isHidden = true
            secondFloorView.isHidden = false
            segmentedControl.selectedSegmentIndex = 1
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along

        if segue.identifier == "firstFloorContainerView" {
            let childViewControllerFirst = segue.destination as! firstFloorViewController
            childViewControllerFirst.firstFloorPoints = firstFloorPoints
            childViewControllerFirst.secondFloorPoints = secondFloorPoints
            
            childViewControllerFirst.distance = distance
            childViewControllerFirst.movement = movement
            childViewControllerFirst.destinationName = destinationName
        }
        
        else if segue.identifier == "secondFloorContainerView" {
            let childViewControllerSecond = segue.destination as! secondFloorViewController
            childViewControllerSecond.secondFloorPoints = secondFloorPoints
            childViewControllerSecond.firstFloorPoints = firstFloorPoints
            
            childViewControllerSecond.distance = distance
            childViewControllerSecond.movement = movement
            childViewControllerSecond.destinationName = destinationName
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
