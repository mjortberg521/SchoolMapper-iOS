//  Copyright © 2018 Matthew Jortberg. All rights reserved.
import Foundation
import SystemConfiguration
import UIKit
import CoreLocation
import CoreMotion
import GameplayKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

let myGraph = GKGraph()
var school = School(schoolName: "Glenbrook South High School")

class MyNode: GKGraphNode {
    let name: String
    var travelCost: [GKGraphNode: Double] = [:] //prev float
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = ""
        super.init()
    }
    
    override func cost(to node: GKGraphNode) -> Float { //override the default weight (1.0)
        return Float(travelCost[node] ?? 0) //return the cost for that specific node from the dictionary (single item-for 1 node only)
    }
    
    func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Double!) {
        self.addConnections(to: [node], bidirectional: bidirectional)
        travelCost[node] = weight
        guard bidirectional else { return }
        (node as? MyNode)?.travelCost[self] = weight //add the weight to the dictionary, assigned to key=node
    }
    
    func removeConnection(to node: GKGraphNode, bidirectional: Bool = true) {
        self.removeConnections(to: [node], bidirectional: bidirectional)
    }
    
    func getName() ->String {
        return name
    }
}

class SourceDestViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    var commonStartLocation = String()
    var commonDestLocation = String()
    
    var sourceRoomPicker: UIPickerView! = UIPickerView()
    var destRoomPicker: UIPickerView! = UIPickerView()
    
    var activeTextField = UITextField()
    let storage = Storage.storage()
    
    @objc func textFieldDidChange(_ textField: UITextField) { //
        if textField.text!.count > 3 {
            textField.text!.removeLast()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { //set the active text field to the current text field --used later to determine which visible field to update w/ the picker value
        
        //add function textFieldDidChange when it is edited; function restricts length to 3 chars
        //this doesn't delete parts of common locations because the display text field is not the activeTextField 
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        //errorMessage.isHidden = true //hide the error message when text field begins editing
        
    
        if textField == commonSourceTextField {
            sourceTextField.text = "" //empty the text fields and hide the error message when the pickers start editing
            //self.errorMessage.isHidden = true
        }
        
        if textField == commonDestTextField {
            destTextField.text = ""
            //self.errorMessage.isHidden = true
        }
 

        activeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged) //add target textFieldDidChange function to limit to 3 characters
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool { //clear the text field and get rid of the error message when the text field is cleared (triggered on begin editing or when the clear button is clicked) -- see before myGraph.add
        //self.errorMessage.isHidden = true
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //general pickerview function; changes commonStartLocation or commonDestLocation when the user selects a row, moving away from default
        
        if let activeTextField = commonSourceTextField { //if the text field (hidden, behind button) is active, make visible text field display the picker value by displaying the commonStartLocation received from the picker
            
            if pickerData.isEmpty == false {
                commonStartLocation = pickerData[row] //overwrites the default (first row in picker) to the one the user has pressed
            }
        }
            
        if let activeTextField = commonDestTextField {
            if pickerData.isEmpty == false {
                commonDestLocation = pickerData[row] //overwrites the default (first row in picker) to the one the user has pressed
            }
        }
    }
    
    func isInternetAvailable() -> Bool {
        sockaddr_in()
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    @IBOutlet weak var destTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var commonSourceSelectionButton: UIButton!
    @IBOutlet weak var commonDestSelectionButton: UIButton!
    
    @IBOutlet weak var commonSourceTextField: UITextField!
    @IBOutlet weak var commonDestTextField: UITextField!
    
    var pickerData : [String] = []
    var pickerDataNumbered : [String] = []

    var start: String?
    var end: String?
    
    var floorplanImage = UIImage()
    
    var firstFloorplanImage : UIImage?
    var secondFloorplanImage : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        
        settingsButton.isEnabled = false
        settingsButton.isEnabled = true
        
        super.viewWillAppear(animated)
        navigationItem.title = "Route" //title for number entry page
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }

    func deg2rad(deg:Double) -> Double {
        return deg * 3.1415 / 180
    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / 3.1415
    }
    
    func feetCost(for path: [GKGraphNode]) -> Int {
        var total: Double = 0.0
        for i in 0..<(path.count-1) {
            total += Double(path[i].cost(to: path[i+1])) //error with override before
        } //adds the cost between each subsequent node to the total
        let x = Int(total)
        return x
    }
    
    //modified distance to accept doubles
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515 * 5280
        dist.round()
        
        return dist
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func readDict(name: String) -> [String: AnyObject] { //function to read a plist and convert to dict
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] {
                return result!
            }
        }
        return [:]
    }
    
    func readNeighborsDict(name: String) -> [String: [AnyObject]] { //function to read a plist and convert to dict [String: [String]]
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: [AnyObject]] {
                return result!
            }
        }
        return [:]
    }
    
    func readArray(name: String) -> [String] { //function to read a plist and convert to dict
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String] {
                return result!
            }
        }
        return []
    }
    
    func makeNode(name: String) -> MyNode {
        let newNode = MyNode(name: name)
        return newNode
    }
    
    @objc func sourceTextFieldNextPressed () { //this is for the numberpad entry
        sourceTextField.resignFirstResponder()
        destTextField.becomeFirstResponder()
        //destTextField.text = "" //clear the text field if the next button is clicked; doesn't clear when begins editing from map view
    }
    
    @objc func destTextFieldDonePressed () {
        destTextField.resignFirstResponder()
    }
    
    //initialize dict used to lookup start/end MyNodes from text field string
    var latitudes_first = [String: AnyObject]()
    var latitudes_second = [String: AnyObject]()
    var longitudes_first = [String: AnyObject]()
    var longitudes_second = [String: AnyObject]()
        
    var nodeStrings = [String]()
    var graphNodes = [MyNode: String]()
    var graphNodesFlipped = [String: MyNode]()
    
    let rootRef = Database.database().reference().child("Mobile") //.child("Dev") //only let this use the mobile path
    
    var storageRootRefPath : String = "gs://schoolmapper-e41e5.appspot.com/" //used later on to get a root storage path for schoolName variable

    var schoolName = String()
    
    var feet:(Double, String)! //repairing graph
    
    func addNeighbors(sourceNode:MyNode, array:[MyNode]) { //used to find the weight of the path between two nodes - array is the list of neighbors
        let x = sourceNode.getName() //get the name for the sourcenode (a room # string)
        
        var source_longitude:Double!
        var source_latitude:Double!
        
        if self.latitudes_first.keys.contains(x) {
            source_latitude = (self.latitudes_first[x])?.doubleValue
            source_longitude = (self.longitudes_first[x])?.doubleValue
        }
            
        else if self.latitudes_second.keys.contains(x) {
            source_latitude = (self.latitudes_second[x])?.doubleValue
            source_longitude = (self.longitudes_second[x])?.doubleValue
        }
        
        for node in array { //iterate over the list of neighbors
            let y = node.getName() //get the name of the node, convert to int, and look up in lat/long dict
            
            var dest_longitude:Double! //these must all be nested
            var dest_latitude:Double!
            
            if self.latitudes_first.keys.contains(y) { //checks if the node being connected to is upstairs or downstairs so it knows which plist to look in
                dest_latitude = (self.latitudes_first[y])?.doubleValue
                dest_longitude = (self.longitudes_first[y])?.doubleValue
                
                feet = (self.distance(lat1: Double(source_latitude!), lon1: Double(source_longitude!), lat2: Double(dest_latitude!), lon2: Double(dest_longitude!), unit: "ft"), "feet")
                sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weight
            }
                
            else if self.latitudes_second.keys.contains(y) {
                dest_latitude = (self.latitudes_second[y])?.doubleValue
                dest_longitude = (self.longitudes_second[y])?.doubleValue
                
                feet = (self.distance(lat1: Double(source_latitude!), lon1: Double(source_longitude!), lat2: Double(dest_latitude!), lon2: Double(dest_longitude!), unit: "ft"), "feet")
                sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weight
            }
        }
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

    var neighbors_dict = [String: [AnyObject]]()
    var real_neighbors_dict = [String: [String]]()
    
    var imageStringCoordinateDictFirst = [String : AnyObject]()
    var imageStringCoordinateDictSecond = [String : AnyObject]()
    
    var imageCoordinateDictFirst = [String : CLLocationCoordinate2D]()
    var imageCoordinateDictSecond = [String : CLLocationCoordinate2D]()
    
    var schoolNames = [String]() //used for the table view
    
    var currentLocation: CLLocation?
    let altimeter = CMAltimeter()
    

    func getSchoolSpecificResources (schoolName: String) {
        
        let schoolRootRef = self.rootRef.child(schoolName)
        let imageRootRef = schoolRootRef.child("Image data")
        
        let pickerDataRootRef = schoolRootRef.child("Common locations")
        pickerDataRootRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.pickerData = (snapshot.value as? [AnyObject])! as! [String]
        })
        
        //get the dict for the image coordinates from Firebase
        imageRootRef.child("First floor").observeSingleEvent(of: .value, with: { (snapshot) in
            self.imageStringCoordinateDictFirst = snapshot.value as? [String : AnyObject] ?? [:]
        })
        
        imageRootRef.child("Second floor").observeSingleEvent(of: .value, with: { (snapshot) in
            self.imageStringCoordinateDictSecond = snapshot.value as? [String : AnyObject] ?? [:]
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
        
        let neighborsRef = schoolRootRef.child("Neighbors") //take the input name and make a childRef
        
        neighborsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.neighbors_dict = snapshot.value as? [String : [AnyObject]] ?? [:]
        })
        
        let schoolStorageRefPath = self.storageRootRefPath+schoolName //gs://schoolmapper-e41e5.appspot.com/Glenbrook South High School
        
        let firstFloorURL = schoolStorageRefPath+"/first-floor.png"
        let firstFloorStorageRef = self.storage.reference(forURL: firstFloorURL)
        
        let secondFloorURL = schoolStorageRefPath+"/second-floor.png"
        let secondFloorStorageRef = self.storage.reference(forURL: secondFloorURL)
        
        firstFloorStorageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("ERROR")
            } else {
                self.firstFloorplanImage = UIImage(data: data!)!
            }
        }
        
        secondFloorStorageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
                print("ERROR")
            } else {
                self.secondFloorplanImage = UIImage(data: data!)!
            }
        }
    }
    
    func showActivityIndicator(uiView: UIView, actInd: UIActivityIndicatorView, container: UIView) {
        
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
        loadingView.center = uiView.center
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
    
    func hideActivityIndicator(uiView: UIView, actInd: UIActivityIndicatorView, container: UIView) {
        
        actInd.stopAnimating()
        container.removeFromSuperview()
    }
    
    //checks if the user is inside the coordinate dictionary for the school
    func isUserLocationValid(coordDict: [String : CLLocationCoordinate2D], userLocation: CLLocationCoordinate2D) -> Bool {
        
        if (coordDict["overlayBottomLeftCoord"]?.latitude)! < userLocation.latitude &&  userLocation.latitude < (coordDict["overlayTopLeftCoord"]?.latitude)! && (coordDict["overlayTopLeftCoord"]?.longitude)! < userLocation.longitude && userLocation.longitude < (coordDict["overlayTopRightCoord"]?.longitude)! {
            
            return true
        }
            
        else {
            return false
        }
    }
    
    let motionManager = CMMotionManager()

    override func viewDidLoad() {
        //motionManager.startAccelerometerUpdates
        
        motionManager.startAccelerometerUpdates()
        
        let locationManager = CLLocationManager()
    
        //locationManager.requestWhenInUseAuthorization()
        let deviceAltitude = locationManager.location?.altitude
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { data, error in
                if (error == nil) {
                    //print(locationManager.location?.altitude)
                    //print("relative Altitude: \(data?.relativeAltitude)")
                    //print("Pressure: \(data?.pressure)")
                }
            })
        }
        
        if CLLocationManager.locationServicesEnabled() {
            // Configure and start the service.
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1.0  // In meters.
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading() //try in ViewDidLoad
        }
        
        func startReceivingLocationChanges() {
            
        }
        
        func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
            let lastLocation = locations.last!
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            if let error = error as? CLError, error.code == .denied {
                // Location updates are not authorized.
                manager.stopUpdatingLocation()
                return
            }
            // Notify the user of any errors.
        }
        
        
        if UserDefaults.standard.value(forKey: "User School Name") == nil {
            //ask the user for the school
            //bring up a searchable table view, which requires grabbing the schoolNames from Firebase dirst
            
            var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            var container: UIView = UIView()
            
            showActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            
            DispatchQueue.global(qos: .utility).async {
                
                repeat {
                    
                    if self.isInternetAvailable() == true { //internet available, loading screen
                        DispatchQueue.main.async {
                            //showActivityIndicatory(uiView: self.view)
                            self.errorMessage.isHidden = true
                        }
                    }
                        
                    else if self.isInternetAvailable() == false { //internet unaivable, main screen with error message
                        DispatchQueue.main.async {
                            self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                            self.errorMessage.text = "No Internet connection"
                            self.errorMessage.isHidden = false
                        }
                    }
                }   while self.schoolNames.isEmpty == true //as long as schoolNames is empty, it will keep checking the internet status
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                    self.schoolName = "not yet selected"
                    
                    self.performSegue(withIdentifier: "segueSettings", sender: self)
                    //take the user to the next screen so they can select their school
                }
            }
            
            let schoolNamesRef = rootRef.child("School Names")
            schoolNamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.schoolNames = (snapshot.value as? [AnyObject])! as! [String]
            })
            
        }
        
        else if UserDefaults.standard.value(forKey: "User School Name") != nil { //if the user default exists, download schoolNames and check if the user's previously selected school is still in the Firebase array
            
            var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            var container: UIView = UIView()
            
            showActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            
            DispatchQueue.global(qos: .utility).async {
                
                repeat {
                    if self.isInternetAvailable() == true { //internet available, loading screen
                        DispatchQueue.main.async {
                            //showActivityIndicatory(uiView: self.view)
                            self.errorMessage.isHidden = true
                        }
                    }
                        
                    else if self.isInternetAvailable() == false { //internet unaivable, main screen with error message
                        DispatchQueue.main.async {
                            self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                            self.errorMessage.text = "No Internet connection"
                            self.errorMessage.isHidden = false
                        }
                    }
                }   while self.schoolNames.isEmpty == true
                
                DispatchQueue.main.async { //this will run after schoolNames is loaded
                    
                    //self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                    
                    if !self.schoolNames.contains(UserDefaults.standard.value(forKey: "User School Name") as! String) {
                        
                        self.errorMessage.text = "Your school is no longer available"
                        self.schoolName = "not available" //workaround so that we have a nonEmpty value (that will be different from the User Default) to compare to so we can reload the data correctly in viewDidAppear if the user's school was deleted between app launches
                        self.errorMessage.isHidden = false
                        self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                        self.performSegue(withIdentifier: "segueSettings", sender: self)
                    } else {
                        //if schoolNames contains our user's school, run the downloads
                        
                        self.schoolName = UserDefaults.standard.value(forKey: "User School Name") as! String
                        
                        DispatchQueue.global(qos: .utility).async {
                            
                            repeat {
                                if self.isInternetAvailable() {
                                    DispatchQueue.main.async {
                                        self.errorMessage.isHidden = true
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                                        self.errorMessage.text = "No Internet connection"
                                        self.errorMessage.isHidden = false
                                    }
                                }
                            }   while self.longitudes_first.isEmpty == true || self.longitudes_second.isEmpty == true || self.latitudes_first.isEmpty == true || self.latitudes_second.isEmpty == true || self.imageStringCoordinateDictFirst.isEmpty == true || self.schoolNames.isEmpty == true || self.imageStringCoordinateDictSecond.isEmpty == true || self.pickerData.isEmpty == true || self.neighbors_dict.isEmpty == true || self.firstFloorplanImage != nil //we use the height property to check if the image is there or not
                            
                            DispatchQueue.main.async {
                                for coord in self.latitudes_first {
                                    if coord.key.count < 4 && coord.key[coord.key.index(coord.key.startIndex, offsetBy: 0)] != "0" {
                                        self.pickerDataNumbered.append(coord.key)
                                    }
                                }
                                
                                for coord in self.latitudes_second {
                                    if coord.key.count < 4 && coord.key[coord.key.index(coord.key.startIndex, offsetBy: 0)] != "0" {
                                        self.pickerDataNumbered.append(coord.key)
                                    }
                                }
                                
                                self.pickerData.append(contentsOf: self.pickerDataNumbered.sorted())
                                
                                self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                                print("all data loaded")
                                
                                self.imageCoordinateDictFirst = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictFirst) //create a dict of CLLocationCoordinates after waiting to recieve a string dictionary from firebase
                                self.imageCoordinateDictSecond = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictSecond)
             
                                for node in self.neighbors_dict.keys { //node is a string
                                    
                                    let newNode = self.makeNode(name: node)
                                    self.graphNodes[newNode] = node
                                    self.graphNodesFlipped[node] = newNode
                                    
                                    myGraph.add([newNode])
                                }
                                
                                for sourceNodeString in self.neighbors_dict.keys { //names in neighbors.plist and nodes.plist must be the same...
                                    
                                    let sourceNode = self.graphNodesFlipped[sourceNodeString]!
                                    var neighborArray = [MyNode]()
                                    
                                    for neighbor in self.self.neighbors_dict[sourceNodeString]! { //iterate through the array of neighbors corresponding to our source node
                                        let destNode = self.graphNodesFlipped[String(describing: neighbor)]! //neighbor is type AnyObject in neighbors_dict; need to convert to string to lookup its corresponding node in graphNodesFlipped
                                        
                                        neighborArray.append(destNode)
                                    }
                                    
                                    self.addNeighbors(sourceNode: sourceNode, array: neighborArray)
                                }
                            }
                        }
                        
                        self.getSchoolSpecificResources(schoolName: self.schoolName) //handle the Firebase resource loading
                        super.viewDidLoad()
                    }
                }
            }
            
            let schoolNamesRef = rootRef.child("School Names")
            schoolNamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.schoolNames = (snapshot.value as? [AnyObject])! as! [String]
            })
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            // Configure and start the service.
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 1.0  // In meters.
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading() //try in ViewDidLoad
        }
        
        func startReceivingLocationChanges() {
            
        }
        
        func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
            let lastLocation = locations.last!
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            if let error = error as? CLError, error.code == .denied {
                manager.stopUpdatingLocation()
                return
            }
        }
        
        if !settingsButton.isEnabled {
            settingsButton.isEnabled = true
        }
        
        super.viewDidAppear(animated)
        
        self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(30,30,30,30)
        
        self.sourceRoomPicker = UIPickerView(frame: self.CGRectMake(0, 40, 0, 0))
        self.destRoomPicker = UIPickerView(frame: self.CGRectMake(0, 40, 0, 0))
        
        self.sourceRoomPicker.delegate = self
        self.sourceRoomPicker.dataSource = self
        
        self.destRoomPicker.delegate = self
        self.destRoomPicker.dataSource = self
        
        //Handle the text field's user input (set this vc as the delegate of the text fields)
        self.sourceTextField.delegate = self
        self.destTextField.delegate = self
        
        //Custom toolbars for the source and dest text fields
        let sourceTooBar: UIToolbar = UIToolbar()
        sourceTooBar.barStyle = UIBarStyle.default
        sourceTooBar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(SourceDestViewController.sourceTextFieldNextPressed))]
        
        sourceTooBar.sizeToFit() //see @objc functions above before viewDidLoad
        self.sourceTextField.inputAccessoryView = sourceTooBar //add it to the source text field as an input accessory
        
        let destTooBar: UIToolbar = UIToolbar()
        destTooBar.barStyle = UIBarStyle.default
        destTooBar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(SourceDestViewController.destTextFieldDonePressed))]
        
        destTooBar.sizeToFit()
        self.destTextField.inputAccessoryView = destTooBar //add it to the dest text field as an input accessory
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let container: UIView = UIView()
        
        if UserDefaults.standard.value(forKey: "User School Name") != nil {
            
            
            if ((UserDefaults.standard.value(forKey: "User School Name") as! String != self.schoolName) && self.schoolName != "") {
                //schoolName is "" whenever the app launches for the first time so setting it to a value even when the school isn't available anymore prevents the downloads from running twice. This statement only runs if the school has been selected and then switched
                //when errors occur with the school not being available on app startup or on very first install, setting schoolName to "not yet selected" makes it so this flow will run and schoolName will be set to the userdefault if still available
                
                schoolNames = []
                showActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            
                DispatchQueue.global(qos: .utility).async {
                    repeat {
                        
                        if self.isInternetAvailable() { //internet available, loading screen
                            DispatchQueue.main.async {
                                self.errorMessage.isHidden = true
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                                self.errorMessage.text = "No Internet connection"
                                self.errorMessage.isHidden = false
                            }
                        }
                    }   while self.schoolNames.isEmpty == true
                    
                    DispatchQueue.main.async {
                        
                        //check if the school we just selected is still available in schoolNames
                        
                        if self.schoolNames.isEmpty == false && self.schoolNames.contains(UserDefaults.standard.value(forKey: "User School Name") as! String) {
                            
                            self.firstFloorplanImage = nil //dump the previous resources
                            self.secondFloorplanImage = nil
                            
                            self.longitudes_first.removeAll()
                            self.longitudes_second.removeAll()
                            self.latitudes_first.removeAll()
                            self.latitudes_second.removeAll()
                            self.pickerData.removeAll()
                            self.pickerDataNumbered.removeAll() //need to clear pickerDataNumbered so that the old school's numbers don't get kept. Everything else is automatically overwritten by getSchoolSpecificResources, but pickerDataNumbered is generated after the downloads so we need to clear it.
                            self.imageStringCoordinateDictFirst.removeAll()
                            self.imageCoordinateDictSecond.removeAll()
                            self.neighbors_dict.removeAll()
                            
                            self.schoolName = UserDefaults.standard.value(forKey: "User School Name") as! String
                            
                            DispatchQueue.global(qos: .utility).async {
                                
                                repeat {
                                    
                                    if self.isInternetAvailable() {
                                        DispatchQueue.main.async {
                                            //showActivityIndicatory(uiView: self.view)
                                            self.errorMessage.isHidden = true
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                                            self.errorMessage.text = "No Internet connection"
                                            self.errorMessage.isHidden = false
                                        }
                                    }
                                }   while self.longitudes_first.isEmpty == true || self.longitudes_second.isEmpty == true || self.latitudes_first.isEmpty == true || self.latitudes_second.isEmpty == true || self.imageStringCoordinateDictFirst.isEmpty == true || self.schoolNames.isEmpty == true || self.imageStringCoordinateDictSecond.isEmpty == true || self.pickerData.isEmpty == true || self.neighbors_dict.isEmpty == true || self.firstFloorplanImage?.size.height == nil || self.secondFloorplanImage?.size.height == nil //we use the height property to check if the image is there or not
                                
                                
                                DispatchQueue.main.async {
                                    
                                    //generate pickerDataNumbered
                                    for coord in self.latitudes_first {
                                        //add all the non "099" or "5001" type points to pickerDataNumbered
                                        if coord.key.count < 4 && coord.key[coord.key.index(coord.key.startIndex, offsetBy: 0)] != "0" {
                                            self.pickerDataNumbered.append(coord.key)
                                        }
                                    }
                                    
                                    for coord in self.latitudes_second {
                                        if coord.key.count < 4 && coord.key[coord.key.index(coord.key.startIndex, offsetBy: 0)] != "0" {
                                            self.pickerDataNumbered.append(coord.key)
                                        }
                                    }
                                    
                                    
                                    //add the list of non-junction or stair numbered rooms to the list of common locations downloaded earlier
                                    self.pickerData.append(contentsOf: self.pickerDataNumbered.sorted())
                                    self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                                    
                                    self.sourceTextField.text = ""
                                    self.destTextField.text = ""
                                    
                                    self.imageCoordinateDictFirst = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictFirst) //create a dict of CLLocationCoordinates after waiting to recieve a string dictionary from firebase
                                    self.imageCoordinateDictSecond = self.self.stringDictToCoordinate(stringDict: self.imageStringCoordinateDictSecond)
                       
                                    for node in self.neighbors_dict.keys { //node is a string
                                    
                                        let newNode = self.makeNode(name: node)
                                        self.graphNodes[newNode] = node
                                        self.graphNodesFlipped[node] = newNode
                                        
                                        myGraph.add([newNode])
                                    }
                                    
                                    for sourceNodeString in self.neighbors_dict.keys {
                                        let sourceNode = self.graphNodesFlipped[sourceNodeString]!
                                        var neighborArray = [MyNode]()
                                        
                                        for neighbor in self.neighbors_dict[sourceNodeString]! {
                                            let destNode = self.graphNodesFlipped[String(describing: neighbor)]!
                                            neighborArray.append(destNode)
                                        }
                                        self.addNeighbors(sourceNode: sourceNode, array: neighborArray)
                                    }
                                }
                            }
                            
                            self.getSchoolSpecificResources(schoolName: self.schoolName)
                        } else {
                            self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                            self.errorMessage.text = "That school is no longer available" //change the text of the error label
                            self.errorMessage.isHidden = false
                            
                            UserDefaults.standard.set(self.schoolName, forKey: "User School Name") //the userDefault was changed in the settings view, but that was an invalid selection since it was changed on Firebase, so we reset the UserDefault to the previous userDefault.//this preserves the nav title for the tab views, which access the user defaults
                        }
                    }
                }
                
                let schoolNamesRef = rootRef.child("School Names")
                schoolNamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    self.schoolNames = (snapshot.value as? [AnyObject])! as! [String]
                })
                
            }
            
            else {
                self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            }
        }
    }

    var routeName = String()

    var distance = Int()
    var lastCoordName = String()
    
    var firstFloorPoints = [String]()
    var secondFloorPoints = [String]()
    
    var movement = String() //variable used to determine whether the user is staying on one floor, moving upstairs, or moving downstairs
    
    /////////////////////////////////////////////////////////////////////
    
    //is this working?
    @IBAction func commonSourceSelectionButtonClicked(_ sender: UIButton) {
        self.commonSourceTextField.becomeFirstResponder() //trigger the text field when the button is clicked, which brings up the picker
        
        //self.errorMessage.isHidden = true
        //reload the picker to the start item
        //sourceRoomPicker.reloadAllComponents()
    }
    
    @IBAction func commonDestSelectionButtonClicked(_ sender: UIButton) {
        self.commonDestTextField.becomeFirstResponder()
        destRoomPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    @objc func doneSourcePicker (sender:UIButton) {
        self.commonSourceTextField.resignFirstResponder()
        sourceTextField.text = commonStartLocation
    }
    
    @objc func doneDestPicker (sender:UIButton) {
        self.commonDestTextField.resignFirstResponder()
        destTextField.text = commonDestLocation
    }
    
    @objc func cancelSourcePicker (sender:UIButton) {
        self.commonSourceTextField.resignFirstResponder()
    }
    
    @objc func cancelDestPicker (sender:UIButton) {
        self.commonDestTextField.resignFirstResponder()
    }
    
    //actions triggered when "or select from list" text field begins editing
    @IBAction func commonSourceTextField(_ sender: UITextField) {
        
        let tintColor: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        inputView.addSubview(sourceRoomPicker)
        
        sourceRoomPicker.tintColor = tintColor
        sourceRoomPicker.center.x = inputView.center.x
        sourceRoomPicker.center.y = inputView.center.y
        
        sourceTextField.text = ""
        
        sourceRoomPicker.selectRow(0, inComponent: 0, animated: false)
        
        if !pickerData.isEmpty {
            commonStartLocation = pickerData[sourceRoomPicker.selectedRow(inComponent: 0)] //set the initial commonStartLocation variable (which is used for sourceTextField.text) to the zeroth row in the picker; this is changed when the user scrolls the picker in didSelectRow
        }
        
        
        let sourceToolBar: UIToolbar = UIToolbar()
        sourceToolBar.barStyle = UIBarStyle.default
        sourceToolBar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneSourcePicker))
        ]
        
        sourceToolBar.sizeToFit()
        commonSourceTextField.inputAccessoryView = sourceToolBar //add it to the picker as an input accessory
        
        sender.inputView = inputView //make the input for the text field the picker we defined w/ its toolbar
 
    }
    
    @IBAction func commonDestTextField(_ sender: UITextField) {
        destTextField.text = ""
        
        destRoomPicker.selectRow(0, inComponent: 0, animated: false)
        
        if !pickerData.isEmpty {
            commonDestLocation = pickerData[destRoomPicker.selectedRow(inComponent: 0)]
        }
        
        let tintColor: UIColor = UIColor(red:0.2, green:0.48, blue:1.00, alpha:1.5)
        
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240)) //create a custom input UIView
        
        destRoomPicker.tintColor = tintColor
        
        destRoomPicker.center.x = inputView.center.x
        destRoomPicker.center.y = inputView.center.y
        
        inputView.addSubview(destRoomPicker) //add the picker to the input view
        
        let destToolBar: UIToolbar = UIToolbar()
        destToolBar.barStyle = UIBarStyle.default
        destToolBar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneDestPicker))
        ]
        
        destToolBar.sizeToFit()
        commonDestTextField.inputAccessoryView = destToolBar //add it to the picker as an input accessory
        
        sender.inputView = inputView
    }
    
    var initialSourceLocationString = String()
    var initialDestLocationString = String()
    
    @IBAction func switchButtonClicked(_ sender: UIButton) {
        initialSourceLocationString = sourceTextField.text!
        
        sourceTextField.text = destTextField.text
        destTextField.text = initialSourceLocationString
    }
    
    @IBAction func settingsButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueSettings", sender: self)
    }
    
    var destinationName = String()

    @IBAction func goButtonClicked(_ sender: UIButton) {
        
        if graphNodesFlipped[destTextField.text!] != nil && graphNodesFlipped[sourceTextField.text!] != nil {
            firstFloorPoints.removeAll()
            secondFloorPoints.removeAll()
            
            var sourceNode : MyNode! = graphNodesFlipped[sourceTextField.text!]
            var destNode : MyNode! = graphNodesFlipped[destTextField.text!]
            
            // hard coded special case
            if schoolName == "Glenbrook South High School" {
                if (sourceNode.getName() == "360" && latitudes_first.keys.contains(destNode.getName()) || destNode.getName() == "360" && latitudes_first.keys.contains(sourceNode.getName())) {
                    sourceNode.removeConnection(to: graphNodesFlipped["066"]!)
                }

            }
            
            var routePath = myGraph.findPath(from: sourceNode, to: destNode) //find the path with builtin GK findPath func
            
            var firstFloorPath = [MyNode]() //used for annotation things...
            var secondFloorPath = [MyNode]()
            
            distance = feetCost(for: routePath) //get the cost of the entire route--works
            
            routeName = sourceTextField.text! + "-" + destTextField.text! //see override func below
            lastCoordName = destTextField.text!
            
            func makeRoutePoints(array : [GKGraphNode]) { //takes routePath as the argument, creates an array of string lat/long coords from plist
                
                array.compactMap({ $0 as? MyNode}).forEach { node in
                    
                    let z = node.getName()
                    
                    var nodeLatitude:Double!
                    var nodeLongitude:Double!
                    
                    if latitudes_first.keys.contains(z) {
                        firstFloorPath.append(node)
                        nodeLatitude = (latitudes_first[z])?.doubleValue
                        nodeLongitude = (longitudes_first[z])?.doubleValue
    
                        var coordString:String = "{"+String(nodeLatitude!)+","
                        coordString+=String(nodeLongitude!) + "}"
                        firstFloorPoints.append(coordString)
                    } else {
                        secondFloorPath.append(node)
                        nodeLatitude = (latitudes_second[z])?.doubleValue
                        nodeLongitude = (longitudes_second[z])?.doubleValue
                        
                        var coordString:String = "{" + String(nodeLatitude!) + ","
                        coordString+=String(nodeLongitude!) + "}"
                        secondFloorPoints.append(coordString)
                    }
                        
                }
                
                if firstFloorPoints.isEmpty == false && secondFloorPoints.isEmpty == true {
                    movement = "first"
                    destinationName = firstFloorPath[firstFloorPath.count-1].getName() //set the name of the destination here to use for the title of the pin in firstFloorViewController since we can't use .getName() on the last point there
                }
                
                else if firstFloorPoints.isEmpty == true && secondFloorPoints.isEmpty == false {
                    movement = "second"
                    destinationName = secondFloorPath[secondFloorPath.count-1].getName()
                }
                
                else if latitudes_first.keys.contains(sourceTextField.text!) && latitudes_second.keys.contains(destTextField.text!) { //lastNode.getName()
                    //if you start on the first floor and end on the second floor
                    movement = "moving_upstairs"
                    destinationName = secondFloorPath[secondFloorPath.count-1].getName()
                }
                    
                else if latitudes_second.keys.contains(sourceTextField.text!) && latitudes_first.keys.contains(destTextField.text!) {
                    //if you start on the second floor and end on the first floor
                    movement = "moving_downstairs"
                    destinationName = firstFloorPath[firstFloorPath.count-1].getName()
                }
            }
            
            makeRoutePoints(array:routePath)
            errorMessage.text = nil
            
            if schoolName == "Glenbrook South High School" {
                graphNodesFlipped["360"]!.addConnection(to: graphNodesFlipped["066"]!, weight: 43) //reconnect 066 to 360 if it was previously removed so that the next time someone wants to go from 360-470, the stairs are available (this is after making the route and coordinates, so it still avoids taking you upstairs on a first floor-first floor route
            }
            
            performSegue(withIdentifier: "segueOptions", sender: self) //name of the identifier is "segueOptions"
            errorMessage.isHidden = true //rehide the error message after a sucessful entry
            
        }
            
        else if graphNodesFlipped[destTextField.text!] == nil || graphNodesFlipped[sourceTextField.text!] == nil{
            errorMessage.text = "Enter a correct start and end point" //change the text of the error label
            errorMessage.isHidden = false
        }
        
        //activityView.stopAnimating()
        
    } //end of goButton action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along
        
        if segue.identifier == "segueOptions" {
            let destViewController = segue.destination as! mapViewController
            destViewController.routeName = routeName //used as nav title in next vc
            destViewController.firstFloorPoints = firstFloorPoints
            destViewController.secondFloorPoints = secondFloorPoints
            
            destViewController.movement = movement
            destViewController.distance = distance
            destViewController.destinationName = destinationName
            destViewController.imageCoordinateDictFirst = imageCoordinateDictFirst
            destViewController.imageCoordinateDictSecond = imageCoordinateDictSecond
            
            destViewController.firstFloorplanImage = firstFloorplanImage!
            destViewController.secondFloorplanImage = secondFloorplanImage!
        }
            
        else if segue.identifier == "segueSettings" {
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! settingsViewController
            tableVC.schoolNames = self.schoolNames
        }

    }
 
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
}
