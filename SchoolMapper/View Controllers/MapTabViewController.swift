//
//  MapTabViewController.swift
//
//  Created by Matthew Jortberg on 2018-04-16.
//  Copyright © 2018 Matthew Jortberg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class mapTabViewController: UIViewController {
    
    //these are the stacked views
    @IBOutlet weak var secondFloorView: UIView!
    @IBOutlet weak var firstFloorView: UIView!
    
    var firstFloorplanImage : UIImage?
    var secondFloorplanImage : UIImage?
    
    var imageStringCoordinateDictFirst = [String : AnyObject]()
    var imageStringCoordinateDictSecond = [String : AnyObject]()
    
    var imageCoordinateDictFirst = [String : CLLocationCoordinate2D]()
    var imageCoordinateDictSecond = [String : CLLocationCoordinate2D]()
    
    var schoolName = String()
    var storageRootRefPath : String = "gs://schoolmapper-e41e5.appspot.com/"
    let rootRef = Database.database().reference()
    let storage = Storage.storage()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: "User School Name") != nil {
            print("userdefaultavailable")
            navigationItem.title = (UserDefaults.standard.value(forKey: "User School Name") as! String)
            //sets the navigation bar title to the school name of the user's pref
        }
            
        else {
            navigationItem.title = "Map"
        }
    }
    
    
    @IBOutlet weak var blueLabel: UILabel! //a blue bar to fix segment formatting
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
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func stringDictToCoordinate(stringDict: [String: AnyObject]) -> [String : CLLocationCoordinate2D]{
        var imageCoordinateDict = [String : CLLocationCoordinate2D]()
        
        for coord in stringDict {
            let point = CGPointFromString(coord.value as! String) //create a CGPoint ({x,y}) given the value (string) in the dictionary
            imageCoordinateDict[coord.key] = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
            //create a new entry in imageCoordinateDict w/ key the string "midCoordinate" or "overlayBottomLeftCoord" and value as CLLocationCoordinate, using the point as input.
            //The point's x and y values are formatted as lat/long, and a coordinate is formatted from these using CLLocationCoordinate2dMake
        }
        return imageCoordinateDict //this is used in first and second floor viewcontrollers to set the vars in the School model required to format the map image
    }
    
    override func viewDidLoad() {
        
        firstFloorView.isHidden = false
        secondFloorView.isHidden = true
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along
        
        if segue.identifier == "firstFloorContainerView" {
            //let childViewControllerFirst = segue.destination as! firstFloorTabViewController
            //childViewControllerFirst.imageCoordinateDict = imageCoordinateDictFirst
            //childViewControllerFirst.firstFloorplanImage = firstFloorplanImage!
        }
            
        else if segue.identifier == "secondFloorContainerView" {
            //let childViewControllerSecond = segue.destination as! secondFloorTabViewController
            //childViewControllerSecond.imageCoordinateDict = imageCoordinateDictSecond
            //childViewControllerSecond.secondFloorplanImage = secondFloorplanImage!
        }
            
        else if segue.identifier == "segueSteps" {
        }
    }
}

