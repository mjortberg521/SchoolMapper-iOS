//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import Foundation
import MapKit

class secondFloorViewController: UIViewController, CLLocationManagerDelegate {
    
    //add the secondFloorMapView from the container's child
    @IBOutlet weak var secondFloorMapView: MKMapView!
    
    var school = School(filename: "GBSF2")
    
    var distance = Int()
    var secondFloorPoints = [String]()
    var firstFloorPoints = [String]()
    
    var movement = String()
    var destinationName = String()
    
    func addAnnotations() {
        let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
        let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
        let coordinate = coords[coords.count-1] //get the last coord- the annotation always needs to be placed at the end of the array
        
        if movement == "second" {
            let type = annotationType(rawValue: "destination") ?? .destination
            
            let annotation = Annotations(coordinate: coordinate, title: destinationName, type: type)
            secondFloorMapView.addAnnotation(annotation)
        }
            
        else if movement == "moving_downstairs" {
            let type = annotationType(rawValue: "moving_downstairs") ?? .moving_downstairs
            
            let annotation = Annotations(coordinate: coordinate, title: "", type: type)
            secondFloorMapView.addAnnotation(annotation)
        }
        
        else if movement == "moving_upstairs" {
            let type = annotationType(rawValue: "destination") ?? .destination
            
            let annotation = Annotations(coordinate: coordinate, title: destinationName, type: type)
            secondFloorMapView.addAnnotation(annotation)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondFloorMapView.showsCompass = true
        secondFloorMapView.showsUserLocation = true
        secondFloorMapView.delegate = self
        
        
        //let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
        //let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let overlay = SchoolMapOverlay(school: school)
        secondFloorMapView.add(overlay)
        
        if secondFloorPoints.isEmpty == false  {
            let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
            let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
            
            let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
            secondFloorMapView.add(myPolyline)
            
            var latDelta = Double()
            latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude)
            latDelta+=latDelta/3 //add a slight buffer to allow viewing of space around start and end point
            
            var lonDelta = Double()
            lonDelta = (coords[(coords.count)-1]).longitude-(coords[0]).longitude
            lonDelta+=lonDelta/3
            
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            let midPoint = centerCoordinate(forCoordinates: coords)
            let region = MKCoordinateRegionMake(midPoint, span) //center the view on the endpoint lat/long
            
            secondFloorMapView.setRegion(region, animated: true)
            
            if coords.count == 1 {
                self.secondFloorMapView.camera.pitch = 45
            }
                
            else {
                var circles = [MKOverlay]()
                
                let outerCircleOverlay = MKCircle(center: coords[0], radius: 2.5)
                let innerCircleOverlay = MKCircle(center: coords[0], radius: 2)
                
                circles.append(outerCircleOverlay)
                circles.append(innerCircleOverlay)
                
                secondFloorMapView.addOverlays(circles, level: MKOverlayLevel.aboveLabels)
                
                var heading = Double()
                heading = getStartHeading(coords: coords)
                
                //self.firstFloorMapView.camera.altitude = 1000 as? CLLocationDistance ?? CLLocationDistance()
                self.secondFloorMapView.camera.pitch = 45
                self.secondFloorMapView.camera.heading = heading
                //self.firstFloorMapView.camera.altitude = 890.00 as? CLLocationDistance ?? CLLocationDistance()
            }
            
            addAnnotations()
        }
            
        else if secondFloorPoints.isEmpty == true {
            let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
            let lonDelta = school.overlayTopLeftCoordinate.longitude - school.overlayBottomRightCoordinate.longitude
            let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
            
            let center = school.midCoordinate
            let region = MKCoordinateRegionMake(center, span)
            
            secondFloorMapView.setRegion(region, animated: true)
            //self.firstFloorMapView.camera.altitude = 890.00 as? CLLocationDistance ?? CLLocationDistance()
        }
    }
    
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
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        //let lastLocation = locations.last!
        // Do something with the location.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
    
    // enforce minimum zoom level
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        var modifyingMap = Bool()
        if self.secondFloorMapView.camera.altitude > 1100.00 && !modifyingMap {
            modifyingMap = true
            //prevent infinite loop
            
            self.secondFloorMapView.camera.altitude = 1099.00 as CLLocationDistance //?? CLLocationDistance()
            
            if secondFloorPoints.isEmpty == false {
                let cgPoints = secondFloorPoints.map { CGPointFromString($0) }
                let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
                
                //center the map on the user's route
                var latDelta = Double()
                latDelta = ((coords[(coords.count)-1]).latitude-(coords[0]).latitude)
                latDelta+=latDelta/3 //add a slight buffer to allow viewing of space around start and end point
                
                var lonDelta = Double()
                lonDelta = (coords[(coords.count)-1]).longitude-(coords[0]).longitude
                lonDelta+=lonDelta/3
                
                let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                
                let midPoint = centerCoordinate(forCoordinates: coords) //get the middle coordinate of the route
                let region = MKCoordinateRegionMake(midPoint, span) //center the view on the endpoint lat/long
                
                secondFloorMapView.setRegion(region, animated: true) //setting the correct region
            }
                
            else if secondFloorPoints.isEmpty == true { //if the array is empty, center the map on the school center
                let latDelta = school.overlayTopLeftCoordinate.latitude - school.overlayBottomRightCoordinate.latitude
                let lonDelta = school.overlayTopLeftCoordinate.longitude - school.overlayBottomRightCoordinate.longitude
                let span = MKCoordinateSpanMake(fabs(latDelta), fabs(lonDelta)) //prev second argument 0.0
                
                let center = school.midCoordinate
                let region = MKCoordinateRegionMake(center, span)
                
                secondFloorMapView.setRegion(region, animated: true)
            }
            
            modifyingMap = false
        }
    }
    
    class CustomPolyline: MKPolylineRenderer { //custom polyline prevents re-render of thickness in the view
        
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

extension secondFloorViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is SchoolMapOverlay {
            return SchoolMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "GBSF2"))
        } else if overlay is MKPolyline {
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
