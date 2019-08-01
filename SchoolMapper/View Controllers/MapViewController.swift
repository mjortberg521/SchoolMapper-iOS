//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController {

    //these are the stacked views
    @IBOutlet weak var firstFloorView: UIView!
    @IBOutlet weak var secondFloorView: UIView!

    //var school = School(filename: "GBS")
    
    //vars from previous viewcontroller
    
    var firstFloorplanImage = UIImage()
    var secondFloorplanImage = UIImage()
    
    var routeName = String()
    var distance = Int()
    
    var imageCoordinateDictFirst = [String: CLLocationCoordinate2D]()
    var imageCoordinateDictSecond = [String: CLLocationCoordinate2D]()
    
    var firstFloorPoints = [String]() //working
    var secondFloorPoints = [String]()
    
    var movement = String()
    var destinationName = String()
    
    @IBOutlet weak var distanceButton: UIBarButtonItem!
    
    override func viewWillDisappear(_ animated: Bool) {
        distanceButton.isEnabled = false
        distanceButton.isEnabled = true
    }

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
    
        //self.navigationController.navigationBar.userInteractionEnabled = true

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
            childViewControllerFirst.imageCoordinateDictFirst = imageCoordinateDictFirst
            childViewControllerFirst.firstFloorplanImage = firstFloorplanImage
        }
        
        else if segue.identifier == "secondFloorContainerView" {
            let childViewControllerSecond = segue.destination as! secondFloorViewController
            childViewControllerSecond.secondFloorPoints = secondFloorPoints
            childViewControllerSecond.firstFloorPoints = firstFloorPoints
            
            childViewControllerSecond.distance = distance
            childViewControllerSecond.movement = movement
            childViewControllerSecond.destinationName = destinationName
            childViewControllerSecond.imageCoordinateDictSecond = imageCoordinateDictSecond
            childViewControllerSecond.secondFloorplanImage = secondFloorplanImage
        }
        
        else if segue.identifier == "segueSteps" {
            let DestViewControllerSteps = segue.destination as! StepsViewController
            DestViewControllerSteps.distanceInFeet = distance
        }

    }
}
