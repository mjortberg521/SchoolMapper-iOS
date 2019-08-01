//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import Foundation
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class firstFloorTabViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var firstFloorMapView: MKMapView!
    var schoolName = String() //get this from a NSUserDefault
    var storageRootRefPath : String = "gs://schoolmapper-e41e5.appspot.com/"
    let rootRef = Database.database().reference().child("Mobile")
    let storage = Storage.storage()

    var firstFloorplanImage : UIImage?
    
    var imageStringCoordinateDictFirst = [String : AnyObject]()
    var imageCoordinateDictFirst = [String : CLLocationCoordinate2D]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var school = School(schoolName: "Glenbrook South High School") //this schoolName param shouldn't actually matter...we just need an object to store coordinates to access later
    
    var midCoordinate = CLLocationCoordinate2D()
    var overlayTopLeftCoordinate = CLLocationCoordinate2D()
    var overlayTopRightCoordinate = CLLocationCoordinate2D()
    var overlayBottomLeftCoordinate = CLLocationCoordinate2D()
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude,
                                              overlayTopRightCoordinate.longitude)
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Map"
    }
    
    func formatOverlay(school: School) {
        school.midCoordinate = self.imageCoordinateDictFirst["midCoordinate"]! //make these school variables so the overlay works--the overlay's bounding box is created in school.swift
        school.overlayTopLeftCoordinate = self.imageCoordinateDictFirst["overlayTopLeftCoord"]!
        school.overlayTopRightCoordinate = self.imageCoordinateDictFirst["overlayTopRightCoord"]!
        school.overlayBottomLeftCoordinate = self.imageCoordinateDictFirst["overlayBottomLeftCoord"]!
    }
    
    func showActivityIndicator(uiView: UIView, container: UIView, actInd: UIActivityIndicatorView, calledInViewDidLoad: Bool) {
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        container.addSubview(blurEffectView)
        
        //container.backgroundColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        container.isOpaque = false
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        
        //only in viewDidAppear was the center position actually correct, so we set a flag for viewDidLoad and correct the loadingView center
        if calledInViewDidLoad == true {
            loadingView.center = CGPoint(x: uiView.center.x, y: uiView.center.y*0.75)
        }
        
        else {
            loadingView.center = uiView.center
        }
        
        loadingView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2);
        actInd.startAnimating()
        loadingView.addSubview(actInd)
        
        container.addSubview(loadingView)
        uiView.addSubview(container)
    }
    
    func hideActivityIndicator(uiView: UIView, container: UIView, actInd: UIActivityIndicatorView) {
        actInd.stopAnimating()
        container.removeFromSuperview()
    }
    
    var latitudes_first = [String: AnyObject]()
    var latitudes_second = [String: AnyObject]()
    var longitudes_first = [String: AnyObject]()
    var longitudes_second = [String: AnyObject]()
    
    override func viewDidLoad() {
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let container: UIView = UIView()
        
        if UserDefaults.standard.value(forKey: "User School Name") == nil { //this would happen if the user switched to the map screen without selecting a school first
            
            //the userDefault should never be nil when the tab map is brought up because the user should select one from the intiial table view
        }
            
        else {
            self.schoolName = UserDefaults.standard.value(forKey: "User School Name") as! String
        }
        
        showActivityIndicator(uiView: self.view, container: container, actInd: actInd, calledInViewDidLoad: true)
        //loadingViewCenter: CGPoint(x: container.center.x, y: container.center.y*0.75)
        
        DispatchQueue.global(qos: .utility).async {
            
            repeat {
                print("*")
            }   while self.firstFloorplanImage?.size.height == nil || self.firstFloorplanImage?.size.width == nil || self.imageStringCoordinateDictFirst.isEmpty == true || self.latitudes_first.isEmpty == true || self.latitudes_second.isEmpty == true || self.longitudes_first.isEmpty == true || self.longitudes_second.isEmpty == true
            
            DispatchQueue.main.async {
                self.hideActivityIndicator(uiView: self.view, container: container, actInd: actInd)
                
                self.imageCoordinateDictFirst = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictFirst) //create a dict of CLLocationCoordinates after waiting to recieve a string dictionary from firebase
                
                self.formatOverlay(school: self.school)
                //formatOverlay replaced lines below where the school variables would be set using the imageCoordinateDict
                
                let overlay = SchoolMapOverlay(school: self.school)
                self.firstFloorMapView.add(overlay)
                
                let latDelta = self.school.overlayTopLeftCoordinate.latitude - self.school.overlayBottomRightCoordinate.latitude
                let lonDelta = self.school.overlayTopLeftCoordinate.longitude - self.school.overlayBottomRightCoordinate.longitude
                let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                
                let center = self.school.midCoordinate
                let region = MKCoordinateRegionMake(center, span)
                
                self.firstFloorMapView.setRegion(region, animated: false)
                
                print(self.latitudes_first)
            }
        }
        
        let schoolRootRef = self.rootRef.child(self.schoolName)
        let imageRootRef = schoolRootRef.child("Image data")
        
        imageRootRef.child("First floor").observeSingleEvent(of: .value, with: { (snapshot) in
            self.imageStringCoordinateDictFirst = snapshot.value as? [String : AnyObject] ?? [:]
        })
        
        schoolRootRef.child("Latitudes_first").observeSingleEvent(of: .value, with: { (snapshot) in
            self.latitudes_first = snapshot.value as? [String: AnyObject] ?? [:]
        })
        
        schoolRootRef.child("Latitudes_second").observeSingleEvent(of: .value, with: { (snapshot) in
            self.latitudes_second = snapshot.value as? [String: AnyObject] ?? [:]
        })
        
        schoolRootRef.child("Longitudes_first").observeSingleEvent(of: .value, with: { (snapshot) in
            self.longitudes_first = snapshot.value as? [String: AnyObject] ?? [:]
        })
        
        schoolRootRef.child("Longitudes_second").observeSingleEvent(of: .value, with: { (snapshot) in
            self.longitudes_second = snapshot.value as? [String: AnyObject] ?? [:]
        })
        
        let schoolStorageRefPath = self.storageRootRefPath+self.schoolName
        //self.navigationController.navigationBar.userInteractionEnabled = true
        
        let firstFloorURL = schoolStorageRefPath+"/first-floor.png"
        let firstFloorStorageRef = self.storage.reference(forURL: firstFloorURL)
        
        firstFloorStorageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("ERROR")
            } else {
                self.firstFloorplanImage = UIImage(data: data!)!
            }
        }
        
        super.viewDidLoad()
        firstFloorMapView.showsCompass = true
        firstFloorMapView.showsUserLocation = true
        firstFloorMapView.showsPointsOfInterest = false
        firstFloorMapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
    
        if UserDefaults.standard.value(forKey: "User School Name") != nil {
            
            if UserDefaults.standard.value(forKey: "User School Name") as! String != schoolName { //this schoolName var is different from the one in sourcedestviewcontroller
                
                self.firstFloorplanImage = nil //dump the previous image
                
                //checks if the default was switched so we can now reload the data
                //this would occur if the user went back to the route entry, switched schools, and went back to the map. It will now reload with the correct map image
                
                schoolName = UserDefaults.standard.value(forKey: "User School Name") as! String
                
                var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
                var container: UIView = UIView()
                
                showActivityIndicator(uiView: self.view, container: container, actInd: actInd, calledInViewDidLoad: false)
                
                DispatchQueue.global(qos: .utility).async {
                    
                    repeat {
                        print("*")

                    }   while self.firstFloorplanImage?.size.height == nil || self.firstFloorplanImage?.size.width == nil || self.imageStringCoordinateDictFirst.isEmpty == true || self.latitudes_first.isEmpty == true || self.latitudes_second.isEmpty == true || self.longitudes_first.isEmpty == true || self.longitudes_second.isEmpty == true
                    
                    DispatchQueue.main.async {
                        self.hideActivityIndicator(uiView: self.view, container: container, actInd: actInd)
                        self.imageCoordinateDictFirst = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictFirst) //create a dict of CLLocationCoordinates after waiting to recieve a string dictionary from firebase
                        
                        self.formatOverlay(school: self.school)
                        
                        let overlay = SchoolMapOverlay(school: self.school)
                        self.firstFloorMapView.add(overlay)
                        
                        let latDelta = self.school.overlayTopLeftCoordinate.latitude - self.school.overlayBottomRightCoordinate.latitude
                        let lonDelta = self.school.overlayTopLeftCoordinate.longitude - self.school.overlayBottomRightCoordinate.longitude
                        let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                        
                        let center = self.school.midCoordinate
                        let region = MKCoordinateRegionMake(center, span)
                        
                        self.firstFloorMapView.setRegion(region, animated: false)
                    }
                }
                
                let schoolRootRef = self.rootRef.child(self.schoolName)
                let imageRootRef = schoolRootRef.child("Image data")
                
                imageRootRef.child("First floor").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.imageStringCoordinateDictFirst = snapshot.value as? [String : AnyObject] ?? [:]
                })
                
                schoolRootRef.child("Latitudes_first").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.latitudes_first = snapshot.value as? [String: AnyObject] ?? [:]
                })
                
                schoolRootRef.child("Latitudes_second").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.latitudes_second = snapshot.value as? [String: AnyObject] ?? [:]
                })
                
                schoolRootRef.child("Longitudes_first").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.longitudes_first = snapshot.value as? [String: AnyObject] ?? [:]
                })
                
                schoolRootRef.child("Longitudes_second").observeSingleEvent(of: .value, with: { (snapshot) in
                    self.longitudes_second = snapshot.value as? [String: AnyObject] ?? [:]
                })
                
                let schoolStorageRefPath = self.storageRootRefPath+self.schoolName
                //self.navigationController.navigationBar.userInteractionEnabled = true
                
                let firstFloorURL = schoolStorageRefPath+"/first-floor.png"
                let firstFloorStorageRef = self.storage.reference(forURL: firstFloorURL)
                
                firstFloorStorageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                        print("ERROR")
                    } else {
                        self.firstFloorplanImage = UIImage(data: data!)!
                    }
                }
            }
            
        }
        
    }
    //var userHeading: CLLocationDirection?
    
    func startReceivingLocationChanges() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            
            return
        }
        
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading() //try in ViewDidLoad
    }
    
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        //let lastLocation = locations.last!
        // Do something with the location.
    }
    
    /*
     func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
     if newHeading.headingAccuracy < 0 { return }
     
     let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
     userHeading = heading
     self.updateHeadingRotation()
     //updateHeadingRotation()
     //NotificationCenter.default.post(name: Notification.Name(rawValue: #YOUR KEY#), object: self, userInfo: nil)
     }
     */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    func registerRegion(withCircularOverlay overlay: MKCircle, andIdentifier identifier: String) {
        // If the overlay's radius is too large, registration fails automatically,
        // so clamp the radius to the max value.
        var radius: CLLocationDistance = overlay.radius
        if radius > locationManager.maximumRegionMonitoringDistance {
            radius = locationManager.maximumRegionMonitoringDistance
        }
        // Create the geographic region to be monitored.
        let geoRegion = CLCircularRegion(center: overlay.coordinate, radius: radius, identifier: identifier)
        locationManager.startMonitoring(for: geoRegion)
    }
    
    // enforce minimum zoom level
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        print(modifyingMap)
        if self.firstFloorMapView.camera.altitude > 1100.00 && !modifyingMap {
            modifyingMap = true
            //prevent infinite loop
            
            self.firstFloorMapView.camera.altitude = 1099.00 as CLLocationDistance //?? CLLocationDistance()
            
            let latDelta = self.school.overlayTopLeftCoordinate.latitude - self.school.overlayBottomRightCoordinate.latitude
            let lonDelta = self.school.overlayTopLeftCoordinate.longitude - self.school.overlayBottomRightCoordinate.longitude
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            let center = self.school.midCoordinate
            let region = MKCoordinateRegionMake(center, span)
            
            firstFloorMapView.setRegion(region, animated: true)
            
            modifyingMap = false
        }
    }
    
    class CustomPolyline: MKPolylineRenderer {
        
        override func applyStrokeProperties(to context: CGContext, atZoomScale zoomScale: MKZoomScale) {
            super.applyStrokeProperties(to: context, atZoomScale: zoomScale)
            UIGraphicsPushContext(context)
            if let ctx = UIGraphicsGetCurrentContext() {
                ctx.setLineWidth(self.lineWidth)
            }
        }
    }
    
    //var headingImageView: UIImageView?
}

//MKMapViewDelegate
extension firstFloorTabViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SchoolMapOverlay {
            return SchoolMapOverlayView(overlay: overlay, overlayImage: firstFloorplanImage!) //#imageLiteral
        }
            
        else if overlay is MKPolyline {
            let lineView = CustomPolyline(overlay: overlay)
            lineView.strokeColor = UIColor(red:0.2, green:0.48, blue:1.00, alpha:1.0)
            lineView.lineWidth = 16
            
            return lineView
        }
            
        else if let overlay = overlay as? MKCircle {
            if overlay.radius == 2.5 {
                let circleRenderer = MKCircleRenderer(circle: overlay)
                circleRenderer.fillColor = UIColor.black
                
                return circleRenderer
            }
                
            else if overlay.radius == 2 {
                let circleRenderer = MKCircleRenderer(circle: overlay)
                circleRenderer.fillColor = UIColor.white
                
                return circleRenderer
            }
            
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.canShowCallout = false
        
        return annotationView
    }
}

/*
extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 3, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
        }, completion: nil)
    }
}
*/

