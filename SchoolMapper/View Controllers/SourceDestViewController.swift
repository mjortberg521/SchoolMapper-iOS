import Foundation
import UIKit
import GameplayKit

let myGraph = GKGraph()
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
        return Float(travelCost[node] ?? 0)
    }
    
    func addConnection(to node: GKGraphNode, bidirectional: Bool = true, weight: Double!) {
        self.addConnections(to: [node], bidirectional: bidirectional)
        travelCost[node] = weight
        guard bidirectional else { return }
        (node as? MyNode)?.travelCost[self] = weight
    }
    
    func getName() ->String {
        return name
    }
}

class SourceDestViewController: UIViewController, UITextFieldDelegate {
    let rooms = ["333", "331", "198"]
    
    //MARK: Properties
    
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destLabel: UILabel!
    @IBOutlet weak var destTextField: UITextField!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    var start: String?
    var end: String?


    override func viewWillAppear(_ animated: Bool) {
      navigationItem.title = "Route" //title for number entry page
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
    
    override func viewDidLoad() {

        let node374 = MyNode(name: "374")
        let node370 = MyNode(name: "370")
        let node368 = MyNode(name: "368")
        let node366 = MyNode(name: "366")
        let node362 = MyNode(name: "362")
        let node360 = MyNode(name: "360")
        let node333 = MyNode(name: "333")
        let node331 = MyNode(name: "331")
        let node332 = MyNode(name: "332")
        let node339 = MyNode(name: "339")
        let node340 = MyNode(name: "340")
        let node341 = MyNode(name: "341")
        let node344 = MyNode(name: "344")
        let node345 = MyNode(name: "345")
        let node348 = MyNode(name: "348")
        let node349 = MyNode(name: "349")
        let node320 = MyNode(name: "320")
        let node316 = MyNode(name: "316")
        let node312 = MyNode(name: "312")
        let node304 = MyNode(name: "304")
        let node554 = MyNode(name: "554")
        let node556 = MyNode(name: "556")
        let node660 = MyNode(name: "660")
        let node665 = MyNode(name: "665")
        let node663 = MyNode(name: "663")
        let node667 = MyNode(name: "667")
        let node669 = MyNode(name: "669")
        let node661 = MyNode(name: "661")
        let node676 = MyNode(name: "676")
        let node678 = MyNode(name: "678")
        let node680 = MyNode(name: "680")//
        let node682 = MyNode(name: "682")//
        let node690 = MyNode(name: "690")//
        let node548 = MyNode(name: "548")
        let node628 = MyNode(name: "628")
        let node626 = MyNode(name: "626")
        let node624 = MyNode(name: "624")
        
        //let nodeBookstore = MyNode(name: "Bookstore") -get numbers
        let node600 = MyNode(name: "600")
        
        let node605 = MyNode(name: "605")
        let node603 = MyNode(name: "603")
        let node621 = MyNode(name: "621")
        let node620 = MyNode(name: "620")
        let node625 = MyNode(name: "625")
        let node627 = MyNode(name: "627")
        let node616 = MyNode(name: "616")
        let node610 = MyNode(name: "610")
        let node609 = MyNode(name: "609")
        let node607 = MyNode(name: "607")
        let node198 = MyNode(name: "198")
        let node199 = MyNode(name: "199")
        let node197 = MyNode(name: "197")
        let node194 = MyNode(name: "194")
        let node195 = MyNode(name: "195")
        let node193 = MyNode(name: "193")
        let node190 = MyNode(name: "190")
        let node191 = MyNode(name: "191")
        let node160 = MyNode(name: "160")
        let node159 = MyNode(name: "159")
        let node158 = MyNode(name: "158")
        let node157 = MyNode(name: "157")
        let node156 = MyNode(name: "156")
        let node155 = MyNode(name: "155")
        let node154 = MyNode(name: "154")
        let node153 = MyNode(name: "153")
        let node152 = MyNode(name: "152")
        let node151 = MyNode(name: "151")
        let node120 = MyNode(name: "120")
        let node119 = MyNode(name: "119")
        let node118 = MyNode(name: "118")
        let node117 = MyNode(name: "117")
        let node116 = MyNode(name: "116")
        let node112 = MyNode(name: "112")
        let node111 = MyNode(name: "111")
        let node110 = MyNode(name: "110")
        let node109 = MyNode(name: "109")
        let node108 = MyNode(name: "108")
        let node107 = MyNode(name: "107")
        let node103 = MyNode(name: "103")
        let node101 = MyNode(name: "101")
        let node100 = MyNode(name: "100")
        let node121 = MyNode(name: "121")
        let node123 = MyNode(name: "123")
        let node128 = MyNode(name: "128")
        let node122 = MyNode(name: "122")
        let node124 = MyNode(name: "124")
        let node176 = MyNode(name: "176")
        let node183 = MyNode(name: "183")
        let node181 = MyNode(name: "181")
        let node182 = MyNode(name: "182")
        let node184 = MyNode(name: "184")
        let node141 = MyNode(name: "141")
        let node142 = MyNode(name: "142")
        let node140 = MyNode(name: "140")
        let node138 = MyNode(name: "138")
        let node139 = MyNode(name: "139")
        let node135 = MyNode(name: "135")
        let node133 = MyNode(name: "133")
        let node167 = MyNode(name: "167")
        let node166 = MyNode(name: "166")
        let node164 = MyNode(name: "164")
        let node162 = MyNode(name: "162")
        
        let node001 = MyNode(name: "001")
        let node002 = MyNode(name: "002")
        let node003 = MyNode(name: "003")
        let node004 = MyNode(name: "004")
        let node005 = MyNode(name: "005")
        let node006 = MyNode(name: "006")
        let node007 = MyNode(name: "007")
        let node008 = MyNode(name: "008")
        let node009 = MyNode(name: "009")
        let node010 = MyNode(name: "010")
        let node011 = MyNode(name: "011")
        let node012 = MyNode(name: "012")
        let node013 = MyNode(name: "013")
        let node014 = MyNode(name: "014")
        let node015 = MyNode(name: "015")
        let node016 = MyNode(name: "016")
        let node017 = MyNode(name: "017")
        let node018 = MyNode(name: "018")
        let node019 = MyNode(name: "019")
        let node020 = MyNode(name: "020")
        let node021 = MyNode(name: "021")
        let node022 = MyNode(name: "022")
        let node023 = MyNode(name: "023")
        let node024 = MyNode(name: "024")
        let node025 = MyNode(name: "025")
        let node026 = MyNode(name: "026")
        let node027 = MyNode(name: "027")
        let node028 = MyNode(name: "028")
        let node029 = MyNode(name: "029")
        let node030 = MyNode(name: "030")
        let node031 = MyNode(name: "031")
        let node032 = MyNode(name: "032")
        let node033 = MyNode(name: "033")
        let node034 = MyNode(name: "034")
        let node035 = MyNode(name: "035")
        let node036 = MyNode(name: "036")
        let node037 = MyNode(name: "037")
        let node038 = MyNode(name: "038")
        let node039 = MyNode(name: "039")
        let node040 = MyNode(name: "040")
        let node041 = MyNode(name: "041")
        let node042 = MyNode(name: "042")
        let node043 = MyNode(name: "043")
        let node044 = MyNode(name: "044")
        let node045 = MyNode(name: "045")
        let node046 = MyNode(name: "046")
        let node047 = MyNode(name: "047")
        let node048 = MyNode(name: "048")
        let node049 = MyNode(name: "049")
        let node050 = MyNode(name: "050")
        let node051 = MyNode(name: "051")
        let node052 = MyNode(name: "052")
        let node053 = MyNode(name: "053")
        let node054 = MyNode(name: "054")
        let node055 = MyNode(name: "055")
        let node056 = MyNode(name: "056")
        let node057 = MyNode(name: "057")
        let node058 = MyNode(name: "058")
        
        let node801 = MyNode(name: "801")
        //Place 800s here
        
        let node711 = MyNode(name: "711")
        let node713 = MyNode(name: "713")
        let node715 = MyNode(name: "715")
        let node717 = MyNode(name: "717")
        let node712 = MyNode(name: "712")
        let node714 = MyNode(name: "714")
        let node742 = MyNode(name: "742")
        let node537 = MyNode(name: "537")
        let node720 = MyNode(name: "720")
        let node710 = MyNode(name: "710")
        
        
        myGraph.add([node374, node370, node368, node366, node362, node360, node333, node331, node332, node339, node340, node341, node344, node345, node348, node349, node320, node316, node312, node304, node554, node556, node660, node665, node663, node667, node669, node661, node676, node678, node680, node682, node690, node548, node628, node626, node624, /*nodeBookstore*/ node600,  node605, node603, node621, node620, node625, node627, node616, node610, node609, node607, node198, node199, node197, node194, node195, node193, node190, node191, node160, node159, node158, node157, node156, node155, node154, node153, node152, node151, node120, node119, node118, node117, node116, node112, node111, node110, node109, node108, node107, node103, node101, node100, node121, node123, node128, node122, node124, node176, node183, node181, node182, node184, node141, node142, node140, node138, node139, node135, node133, node167, node166, node164, node162, node001, node002, node003, node004, node005, node006, node007, node008, node009, node010, node011, node012, node013, node014, node015, node016, node017, node018, node019, node020, node021, node022, node023, node024, node025, node026, node027, node028, node029, node030, node031, node032, node033, node034, node035, node036, node037, node038, node039, node040, node041, node042, node043, node044, node045, node046, node047, node048, node049, node050, node051, node052, node053, node054, node055, node056, node057, node058, node801, node711, node713, node715, node717, node712, node714, node742, node537, node720, node710
            ])
        
        var feet:(Double, String)! //repairing graph
        func addNeighbors(sourceNode:MyNode, array:[MyNode]) { //used to find the weight of the path between two nodes - array is the list of neighbors
            let x = sourceNode.getName() //get the name for the sourcenode (a room # string)
            print(x)
            
            var source_longitude:Double! //this if statement is now working-------------------------------
            var source_latitude:Double!
            if let path = Bundle.main.path(forResource: "Longitudes_first", ofType: "plist"), let longitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] { //used to be AnyObject
                 //longitudes is the dict from the plist
                
                
                if let path = Bundle.main.path(forResource: "Latitudes_first", ofType: "plist"), let latitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                    
                    if latitudes_first.keys.contains(x) {
                        source_latitude = (latitudes_first[x])?.doubleValue
                        source_longitude = (longitudes_first[x])?.doubleValue
                        
                        print(source_latitude)
                        print(source_longitude)
                    }
                    
                    else {
                        if let path = Bundle.main.path(forResource: "Longitudes_second", ofType: "plist"), let longitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] { //used to be AnyObject
                            //longitudes is the dict from the plist
                            print(source_longitude) //works
                            
                            if let path = Bundle.main.path(forResource: "Latitudes_second", ofType: "plist"), let latitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                                
                                source_latitude = (latitudes_second[x])?.doubleValue
                                source_longitude = (longitudes_second[x])?.doubleValue
                            }
                        }
                    }
            }
        }
            
        
            for node in array { //iterate over the list of neighbors
                let y = node.getName() //get the name of the node, convert to int, and look up in lat/long dict
                
                var dest_longitude:Double! //these must all be nested
                var dest_latitude:Double!
                
                if let path = Bundle.main.path(forResource: "Longitudes_first", ofType: "plist"), let longitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] { //used to be AnyObject
                    //longitudes is the dict from the plist
                    
                    if let path = Bundle.main.path(forResource: "Latitudes_first", ofType: "plist"), let latitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                        
                        if latitudes_first.keys.contains(y) {
                            dest_latitude = (latitudes_first[y])?.doubleValue
                            print(dest_latitude)///////////////
                            dest_longitude = (longitudes_first[y])?.doubleValue
                            print(dest_longitude)////////////////
                            
                            feet = (distance(lat1: Double(source_latitude!), lon1: Double(source_longitude!), lat2: Double(dest_latitude!), lon2: Double(dest_longitude!), unit: "ft"), "feet")
                            sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weightso
                        }
                            
                        else {
                            if let path = Bundle.main.path(forResource: "Longitudes_second", ofType: "plist"), let longitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] { //used to be AnyObject
                                //longitudes is the dict from the plist
                                
                                if let path = Bundle.main.path(forResource: "Latitudes_second", ofType: "plist"), let latitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                                    
                                    dest_latitude = (latitudes_second[y])?.doubleValue
                                    dest_longitude = (longitudes_second[y])?.doubleValue
                                }
                            }
                        }
                    }
                }
                                    
            }
        } //end addNeighbors
        
        //SETUP THE GRAPH
        var neighbors_dict = [MyNode: [MyNode]]()
        neighbors_dict = [node001: [node366, node362, node002],
                          node374: [node370, node368],
                          node370: [node374, node366, node368],
                          node368: [node374, node366],
                          node366: [node370, node368, node362, node001],
                          node362: [node001, node360],
                          node360: [node362],
                          node002: [node333, node339, node003],
                          node333: [node002, node331],
                          node331: [node333, node033],
                          node332: [node331, node333],
                          node339: [node002, node341],
                          node340: [node341, node339, node345, node344],
                          node341: [node340, node339, node345, node344],
                          node344: [node345, node340, node341, node348, node349],
                          node345: [node344, node340, node341, node348, node349],
                          node349: [node348, node344, node345],
                          node348: [node349, node345, node344],
                          node003: [node004, node304],
                          node004: [node003, node312, node548],
                          node312: [node004, node316],
                          node316: [node312, node320],
                          node320: [node316],
                          node304: [node003, node031],
                          node537: [node018, node006],
                          node548: [node055, node005],
                          node554: [node055, node556],
                          node556: [node554],
                          
                          node005: [node548, node006, node007, node050],
                          node006: [node007, node005, node537, node050],
                          node007: [node006, node005, node625, node050, node051],
                          node625: [node007, node628, node051],
                          node627: [node050, node035],
                          node628: [node625, node621, node626],
                          node621: [node628, node626],
                          node626: [node628, node624, node009, node621],
                          node009: [node626, node624, node008, node620],
                          node616: [node013],
                          node620: [node009, node605, node603, node013],
                          
                          node624: [node009, node008],
                          node008: [node009, node010],
                          node010: [node008, node011, node022],
                          node011: [node176, /*node166, node167,*/ node016],
                          node176: [node181, node011, node182],
                          node181: [node176, node182, node183],
                          node182: [node176, node184, node181],
                          node183: [node184, node012, node181],
                          node184: [node183, node182, node012],
                          node012: [node190, node191, node184, node183, node014],
                          node190: [node012, node191],
                          node191: [node190, node193, node012],
                          node193: [node191, node195, node190],
                          node194: [node190, node195],
                          node195: [node197, node193, node194],
                          node197: [node199, node195, node194],
                          node198: [node199, node194],
                          node199: [node198, node197],
                          node013: [node034, node620, node616, node605],
                          node014: [node151, node152, node012, node015, /*node142, node141*/],
                          node151: [node014, node152, node153],
                          node152: [node014, node151, node154],
                          node153: [node154, node155, node151],
                          node154: [node156, node153, node152],
                          node155: [node153, node157, node156],
                          node156: [node158, node154, node155],
                          node157: [node159, node155, node158],
                          node158: [node160, node157, node156],
                          node159: [node160, node157],
                          node160: [node159, node158],
                          node015: [node112, node014, node116],
                          node120: [node119],
                          node119: [node120, node118],
                          node118: [node119, node117],
                          node117: [node118, node116],
                          node116: [node117, node112],
                          node112: [node116, node111, node015],
                          node111: [node112, node110],
                          node110: [node111, node109],
                          node109: [node110, node108],
                          node108: [node109, node107],
                          node107: [node108, node103],
                          node103: [node107, node101],
                          node101: [node103, node100],
                          node100: [node101, node019],
                          node016: [node011, node017, node128, /*node133, nurse*/],
                          node017: [node103, node107],
                          node018: [node537],
                          node019: [node020, node100],
                          node020: [node019, node121, node801],
                          node121: [node123, node020],
                          node801: [node020, node021],
                          node021: [node801, node022, /*node162*/],
                          node022: [node021, node023],
                          node023: [node024, node022],
                          node024: [node023, node025],
                          node025: [node026, node024],
                          node026: [node025, node027],
                          node027: [node026, node028],
                          node028: [node027, node029],
                          node029: [node028, node030],
                          node030: [node029, node031, node032],
                          node031: [node304, node030],
                          node032: [node030, node033],
                          node033: [node032, node331],
                          node034: [node013, node012, node610],
                          node610: [node034, node607],
                          node607: [node610, node609],
                          node609: [node607],
                          node605: [node013, node620, node603],
                          node603: [node009, node605, node620],
                          node035: [node627, node036, node037],
                          node036: [node035],
                          node037: [node035, node038],
                          node038: [node037, node039],
                          node039: [node038, node040],
                          node040: [node039, node041],
                          node041: [node040, node042],
                          node042: [node041, node043],
                          node043: [node042, node044],
                          node044: [node045, node043],
                          node045: [node044, node046],
                          node046: [node047, node045],
                          node047: [node711, node048, node046],
                          node048: [node047, node049],
                          node049: [node713, node048, node742],
                          node050: [node627, node006, node005, node007],
                          node051: [node625, node007, node628, node663],
                          node052: [node660, node669, node054, node678],
                          node053: [node665, node663, node660, node661],
                          node054: [node676, node678, node052],
                          node055: [node548, node554, node004],
                          node056: [node046, node057],
                          node057: [node056, node058],
                          node058: [node057, node720, node710],
                          node711: [node047],
                          node713: [node049, node715],
                          node715: [node713, node717],
                          node717: [node712, node715],
                          node712: [node717, node714],
                          node714: [node742, node712],
                          node742: [node714, node049],
                          node710: [node058, node720],
                          node720: [node058, node710],
                          //add red here
                          node660: [node667, node052, node053],
                          node665: [node053],
                          node663: [node051, node053],
                          node667: [node660, node669, node665],
                          node669: [node667, node052, node676],
                          node661: [node053],
                          node676: [node669, node054],
                          node678: [node054, node052],
                          //add red here
        ]
        
        for (node,neighbors) in neighbors_dict {
            addNeighbors(sourceNode: node, array: neighbors)
            print(neighbors)
        }
        
        super.viewDidLoad()
        //Handle the text field's user input through delegate callbacks (set this vc as the delegate of the text fields)
        sourceTextField.delegate = self
        destTextField.delegate = self
    }

    var routeName = String()
    var nodeNameDict = [String: MyNode]() //dict used to lookup start/end MyNodes from text field string

    var distance = Int()
    var lastCoordName = String()
    
    var firstFloorPoints = [String]()
    var secondFloorPoints = [String]()
    
    var movement = String() //variable used to determine whether the user is staying on one floor, moving upstairs, or moving downstairs
    
    @IBAction func goButtonClicked(_ sender: UIButton) {
        myGraph.nodes!.flatMap({ $0 as? MyNode}).forEach { node in //run through myGraph
            nodeNameDict[node.name] = node //add the node to the dict [name:node] --used to lookup node given string entered in text field
        }
        
        if nodeNameDict[destTextField.text!] != nil && nodeNameDict[sourceTextField.text!] != nil{ //check if the entries are valid
            firstFloorPoints.removeAll() //must reset these to empty arrs, prevents inclusion of previous routes
            secondFloorPoints.removeAll()
            
            var sourceNode:MyNode! = nodeNameDict[sourceTextField.text!] //use the text to lookup the sourcenode--string must be the nodename
            var destNode:MyNode! = nodeNameDict[destTextField.text!]
            
            var routePath = myGraph.findPath(from: sourceNode, to: destNode) //find the path with builtin GK findPath func
            var firstFloorPath = [MyNode]()
            var secondFloorPath = [MyNode]()
            
            print("RPRP")
            print(routePath) //this array is not empty, it contains myNode types
            distance = feetCost(for: routePath) //get the cost of the entire route--works
            
            routeName = sourceTextField.text! + "-" + destTextField.text! //see override func below
            lastCoordName = destTextField.text!
            print(routeName)
            
            
            func makeRoutePoints(array:[GKGraphNode]) { //takes path as the argument, creates an array of string lat/long coords from plist
                let fileManager = FileManager.default
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                
                array.flatMap({ $0 as? MyNode}).forEach { node in
                    
                    let z = node.getName() //name is used to lookup lat/long
                    
                    var nodeLatitude:Double!
                    var nodeLongitude:Double!
                    
                    if let path = Bundle.main.path(forResource: "Latitudes_first", ofType: "plist"), let latitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                        if let path = Bundle.main.path(forResource: "Latitudes_second", ofType: "plist"), let latitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                            if let path = Bundle.main.path(forResource: "Longitudes_first", ofType: "plist"), let longitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                                if let path = Bundle.main.path(forResource: "Longitudes_second", ofType: "plist"), let longitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                                    
                                    if latitudes_first.keys.contains(z) {
                                        firstFloorPath.append(node)
                                        nodeLatitude = (latitudes_first[z])?.doubleValue
                                        nodeLongitude = (longitudes_first[z])?.doubleValue
                                        
                                        print(nodeLatitude)
                                        print(nodeLongitude)
                                        
                                        var coordString:String = "{"+String(nodeLatitude!)+","
                                        coordString+=String(nodeLongitude!)+"}"  //must have !
                                        firstFloorPoints.append(coordString) //contains an array of strings (coordinates)
                                    }
                                        
                                    else{
                                        secondFloorPath.append(node)
                                        nodeLatitude = (latitudes_second[z])?.doubleValue
                                        nodeLongitude = (longitudes_second[z])?.doubleValue
                                        
                                        var coordString:String = "{"+String(nodeLatitude!)+","
                                        coordString+=String(nodeLongitude!)+"}"  //must have !
                                        secondFloorPoints.append(coordString) //contains an array of strings (coordinates)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                
                if firstFloorPoints.isEmpty == false && secondFloorPoints.isEmpty == true {
                    movement = "first"
                }
                
                else if firstFloorPoints.isEmpty == true && secondFloorPoints.isEmpty == false {
                    movement = "second"
                }
                
                else if let path = Bundle.main.path(forResource: "Latitudes_first", ofType: "plist"), let latitudes_first = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                     if let path = Bundle.main.path(forResource: "Latitudes_second", ofType: "plist"), let latitudes_second = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                        //var firstNode:MyNode!
                        //firstNode = array[0] as! MyNode
                        
                        //var lastNode:MyNode!
                        //lastNode = array[array.count-1] as! MyNode
                        
                        if latitudes_first.keys.contains(sourceTextField.text!) && latitudes_second.keys.contains(destTextField.text!) { //lastNode.getName()
                            //if you start on the first floor and end on the second floor
                            movement = "moving_upstairs"
                        }
                            
                        else if latitudes_second.keys.contains(sourceTextField.text!) && latitudes_first.keys.contains(destTextField.text!) {
                            //if you start on the second floor and end on the first floor
                            movement = "moving_downstairs"
                        }
                    }
                }
            } //these are all good
            
            makeRoutePoints(array:routePath) //changes the array firstFloorPoints
            print("firstfloorpoints")
            print(firstFloorPoints)

            errorMessage.text = nil
            performSegue(withIdentifier: "segueOptions", sender: self) //name of the identifier is "segueOptions"
        }
            
        else if nodeNameDict[destTextField.text!] == nil || nodeNameDict[sourceTextField.text!] == nil{
            errorMessage.text = "Error: Enter a correct start and end point" //change the text of the error label
        }
        
    } //end of goButton action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along
        var DestViewController = segue.destination as! mapViewController
        DestViewController.routeName = routeName //used as nav title in next vc
        DestViewController.firstFloorPoints = firstFloorPoints
        DestViewController.secondFloorPoints = secondFloorPoints
        DestViewController.movement = movement
        DestViewController.distance = distance
    }
 
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    //Mark: Actions
}
