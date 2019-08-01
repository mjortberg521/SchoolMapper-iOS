//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import Foundation
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class firstFloorViewController: UIViewController, CLLocationManagerDelegate {
        
    //@IBOutlet weak var firstFloorMapView: MKMapView!
    
    @IBOutlet weak var firstFloorMapView: MKMapView!
    
    var schoolName = String()
    var school = School(schoolName: "Glenbrook South High School") //the name corresponding to our school--this doesn't persist, so we can't set the imageCoordinateDict to something in SourceDestViewController and expect to access it again here
    
    var imageCoordinateDictFirst = [String: CLLocationCoordinate2D]()
    
    var distance = Int()
    var firstFloorPoints = [String]() //all the coordinates are being passed along
    var secondFloorPoints = [String]()
    
    var movement = String()
    var destinationName = String()
    
    let storage = Storage.storage()
    var firstFloorplanImage = UIImage()
    
    func addAnnotations() {
        let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let lastCoordinateOnFloor = coords[coords.count-1] //get the last coord in the first floor array
        //let firstCoordinateOnFloor = coords[0]
        
        if movement == "first" {
            let type = annotationType(rawValue: "destination") ?? .destination //this is the same rawValue as Annotations.swift enum case
            let annotation = Annotations(coordinate: lastCoordinateOnFloor, title: destinationName, type: type) //title not working...it doesn't need to though
            firstFloorMapView.addAnnotation(annotation)
            
            //let type1 = annotationType(rawValue: "starting") ?? .starting //add the starting arrow
            //let startingAnnotation = Annotations(coordinate: firstCoordinateOnFloor, title: "", type: type1)
            //firstFloorMapView.addAnnotation(startingAnnotation)
        }
            
        else if movement == "moving_upstairs" {
            let type = annotationType(rawValue: "moving_upstairs") ?? .moving_upstairs //this is the same rawValue as Annotations.swift enum case
            let annotation = Annotations(coordinate: lastCoordinateOnFloor, title: "stairs", type: type)
            firstFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_downstairs" {
            let type = annotationType(rawValue: "destination") ?? .destination //this is the same rawValue as Annotations.swift enum case
            let annotation = Annotations(coordinate: lastCoordinateOnFloor, title: destinationName, type: type)
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
    
    
    func getStartHeading (coords: [CLLocationCoordinate2D]) -> CLLocationDirection {
    //latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude)
    
        var latDelta = Double()
        var lonDelta = Double()
        
        latDelta = coords[1].latitude-coords[0].latitude
        lonDelta = coords[1].longitude-coords[0].longitude
        
        var y = Double()
        var x = Double()
        var brng = Double()
        
        y = sin(lonDelta) * cos(latDelta)
        x = cos(coords[0].latitude) * sin(coords[1].latitude) - sin(coords[0].latitude) * cos(coords[1].latitude) * cos(lonDelta)
        
        brng = atan2(y, x)
        
        brng = rad2deg(rad: brng)
        brng = (brng + 360) .truncatingRemainder(dividingBy: 360)
        //brng = 360 - brng // count degrees counter-clockwise - remove to make clockwise
        return brng
    }
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
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

    override func viewDidLoad() {
        
        print("IMAGECOORDINATEDICT")
        print(imageCoordinateDictFirst)
        
        school.midCoordinate = imageCoordinateDictFirst["midCoordinate"]! //make these school variables so the overlay works--the overlay's bounding box is created in school.swift
        school.overlayTopLeftCoordinate = imageCoordinateDictFirst["overlayTopLeftCoord"]!
        school.overlayTopRightCoordinate = imageCoordinateDictFirst["overlayTopRightCoord"]!
        school.overlayBottomLeftCoordinate = imageCoordinateDictFirst["overlayBottomLeftCoord"]!
        
        super.viewDidLoad()
        firstFloorMapView.showsCompass = true
        firstFloorMapView.showsUserLocation = false
        firstFloorMapView.showsPointsOfInterest = false
        firstFloorMapView.delegate = self
        
        print("firstFloorplanImage")
        print(firstFloorplanImage)
        
        //locationManager.requestWhenInUseAuthorization()
        
        let overlay = SchoolMapOverlay(school: school)
        firstFloorMapView.add(overlay)
        
        if firstFloorPoints.isEmpty == false { //center the view on the route area
            let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }

            let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
            firstFloorMapView.add(myPolyline)
            
            var latDelta = Double()
            latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude) //the lat distance between start and end points
            latDelta+=latDelta/4 //add a slight buffer to allow viewing of space around start and end point
            
            var lonDelta = Double()
            lonDelta = (coords[(coords.count)-1]).longitude-(coords[0]).longitude
            lonDelta+=lonDelta/4
            
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta))
            
            let midPoint = centerCoordinate(forCoordinates: coords)
            let region = MKCoordinateRegionMake(midPoint, span) //center the view on the middle lat/long
            
            firstFloorMapView.setRegion(region, animated: true)
            
            if coords.count == 1 {
                self.firstFloorMapView.camera.pitch = 45
            }
                
            else { //if the route moves between more than two rooms (the normal case), set the heading to the direction of the first step (the angle from first pt to second pt)
                var circles = [MKOverlay]()
                
                let outerCircleOverlay = MKCircle(center: coords[0], radius: 2.5)
                let innerCircleOverlay = MKCircle(center: coords[0], radius: 2)
                
                circles.append(outerCircleOverlay)
                circles.append(innerCircleOverlay)
 
                firstFloorMapView.addOverlays(circles, level: MKOverlayLevel.aboveLabels)
                
                var heading = Double()
                heading = getStartHeading(coords: coords)
                
                firstFloorMapView.camera.pitch = 45
                firstFloorMapView.camera.heading = heading
                //self.firstFloorMapView.camera.altitude = 890.00 as? CLLocationDistance ?? CLLocationDistance()
            }
            
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
        
        //firstFloorMapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
    
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
        if self.firstFloorMapView.camera.altitude > 1100.00 && !modifyingMap {
            modifyingMap = true
            //prevent infinite loop

            self.firstFloorMapView.camera.altitude = 1099.00 as CLLocationDistance //?? CLLocationDistance()
            
            if firstFloorPoints.isEmpty == false { //snap back to the route
                let cgPoints = firstFloorPoints.map { CGPointFromString($0) }
                let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
                
                //center the map on the user's route
                var latDelta = Double()
                latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude) //the lat distance between start and end points
                latDelta+=latDelta/3 //add a slight buffer to allow viewing of space around start and end point
                
                var lonDelta = Double()
                lonDelta = (coords[(coords.count)-1]).longitude-(coords[0]).longitude
                lonDelta+=lonDelta/3
                
                let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                
                let midPoint = centerCoordinate(forCoordinates: coords) //to get the geometric midpoint of the route, we call the custom centerCoordinate function here
                let region = MKCoordinateRegionMake(midPoint, span) //center the view on the middle lat/long
                
                firstFloorMapView.setRegion(region, animated: true) //setting the correct region                
            }
            
            else if firstFloorPoints.isEmpty == true { //if the array is empty, center the map on the school center
                let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
                let lonDelta = school.overlayTopLeftCoordinate.longitude - school.overlayBottomRightCoordinate.longitude
                let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                
                let center = school.midCoordinate
                let region = MKCoordinateRegionMake(center, span)
                
                firstFloorMapView.setRegion(region, animated: true)
            }
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
}

//MKMapViewDelegate
extension firstFloorViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SchoolMapOverlay {
            return SchoolMapOverlayView(overlay: overlay, overlayImage: firstFloorplanImage) //#imageLiteral
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
