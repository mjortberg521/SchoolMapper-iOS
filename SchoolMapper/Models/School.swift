//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import UIKit
import MapKit
import Firebase
import FirebaseDatabase

class School {
    var name: String?
    var boundary: [CLLocationCoordinate2D] = []
    let rootRef = Database.database().reference()
    
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
    
    //var imageCoordinateDict = [String: AnyObject]()
    var firstFloorplanImage = UIImage()
    var secondFloorplanImage = UIImage()
    var imageCoordinateDict = [String : CLLocationCoordinate2D]()
    
    var overlayBoundingMapRect: MKMapRect { //create a bounding rectangle for the overlay
        get {
            let topLeft = MKMapPointForCoordinate(overlayTopLeftCoordinate);
            let topRight = MKMapPointForCoordinate(overlayTopRightCoordinate);
            let bottomLeft = MKMapPointForCoordinate(overlayBottomLeftCoordinate);
            
            return MKMapRectMake(
                topLeft.x,
                topLeft.y,
                fabs(topLeft.x - topRight.x),
                fabs(topLeft.y - bottomLeft.y))
        }
    }
    
    func stringToCoordinate(coord: String) -> CLLocationCoordinate2D{
        let point = CGPointFromString(coord)
        print("POINT")
        print(CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y)))
        return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        
        //return CLLocationCoordinate2D()
    }
    
    init (schoolName: String) {
        /*
        DispatchQueue.global(qos: .utility).async {
            
            repeat {
                print("model not ready to go")
            }   while self.imageCoordinateDict.isEmpty == true
            
            DispatchQueue.main.async {
                print(self.imageCoordinateDict)
                print("model ready to go")
                self.midCoordinate = self.imageCoordinateDict["midCoordinate"]!
                self.overlayTopLeftCoordinate = self.imageCoordinateDict["overlayTopLeftCoord"]!
                self.overlayTopRightCoordinate = self.imageCoordinateDict["overlayTopRightCoord"]!
                self.overlayBottomLeftCoordinate = self.imageCoordinateDict["overlayBottomLeftCoord"]!
                print(self.firstFloorplanImage)
            }
        }*/
    }
    
    /*
    init(schoolName: String) {
        let schoolRootRef = rootRef.child(schoolName)
        
        let imageRootRef = schoolRootRef.child("Image data")
        imageRootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.imageCoordinateDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.midCoordinate = self.stringToCoordinate(coord: self.imageCoordinateDict["midCoordinate"] as! String)
            self.overlayTopLeftCoordinate = self.stringToCoordinate(coord: self.imageCoordinateDict["overlayTopLeftCoord"] as! String)
            self.overlayTopRightCoordinate = self.stringToCoordinate(coord: self.imageCoordinateDict["overlayTopRightCoord"] as! String)
            self.overlayBottomLeftCoordinate = self.stringToCoordinate(coord: self.imageCoordinateDict["overlayBottomLeftCoord"] as! String)
        })
    
        
        guard let properties = School.plist(schoolName) as? [String : Any],
            let boundaryPoints = properties["boundary"] as? [String] else { return }
        
        midCoordinate = School.parseCoord(dict: properties, fieldName: "midCoord")
        overlayTopLeftCoordinate = School.parseCoord(dict: properties, fieldName: "overlayTopLeftCoord")
        overlayTopRightCoordinate = School.parseCoord(dict: properties, fieldName: "overlayTopRightCoord")
        overlayBottomLeftCoordinate = School.parseCoord(dict: properties, fieldName: "overlayBottomLeftCoord")
        
        //let cgPoints = boundaryPoints.map { CGPointFromString($0) }
        //boundary = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
 
    }
 */
    
    static func plist(_ plist: String) -> Any? { //deserialize the plist
        guard let filePath = Bundle.main.path(forResource: plist, ofType: "plist"),
            let data = FileManager.default.contents(atPath: filePath) else { return nil }
        
        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        } catch {
            return nil
        }
    }
    
    static func parseCoord(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D{
        if let coord = dict[fieldName] as? String {
            let point = CGPointFromString(coord)
            return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
        }
        return CLLocationCoordinate2D()
    }
}

