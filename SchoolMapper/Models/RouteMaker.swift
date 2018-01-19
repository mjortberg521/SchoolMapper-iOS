import Foundation
import GameplayKit

class RouteMaker {
    var latitudes = [Int: Float]()
    
    static func 
    latitudes = [001: 42.088093,
    374: 42.088093,
    370: 42.088093,
    368: 42.088093,
    366: 42.088093,
    362: 42.088093,
    360: 42.088093,
    333: 42.08822,
    331: 42.08822,
    332: 42.08822,
    339: 42.08822,
    340: 42.08822,
    341: 42.08822,
    344: 42.08822,
    345: 42.08822,
    348: 42.08822,
    349: 42.08822,
    320: 42.088415,
    316: 42.088415,
    312: 42.088415,
    304: 42.088415,
    //554
    //556
    660: 42.088975,
    665: 42.088975,
    667: 42.088975,
    669: 42.088975,
    676: 42.088975,
    678: 42.088975,
    680: 42.088975,
    682: 42.088975,
    690: 42.088975,
    548: 42.088810, //auditorium
    628: 42.088991,
    626: 42.088991,
    624: 42.088991,
    //Book store number: 42.089016
    //Test center number: 42.089016
    605: 42.089194,
    603: 42.089142,
    621: 42.089014,
    620: 42.089158,
    625: 42.089013,
    627: 42.089319,
    616: 42.089305,
    610: 42.0894,
    609: 42.089478,
    607: 42.089437,
    198: 42.08959,
    199: 42.08959,
    197: 42.089531,
    194: 42.089465,
    195: 42.089465,
    193: 42.08941,
    190: 42.08935,
    191: 42.08935,
    160: 42.08959,
    159: 42.08959,
    158: 42.089531,
    157: 42.089531,
    156: 42.089465,
    155: 42.089465,
    154: 42.08941,
    153: 42.08941,
    152: 42.08935,
    151: 42.08935,
    120: 42.089584,
    119: 42.089542,
    118: 42.08946,
    117: 42.089419,
    116: 42.089349,
    112: 42.089264,
    111: 42.089217,
    110: 42.089132,
    109: 42.089084,
    108: 42.089028,
    107: 42.08899,
    103: 42.08889,
    101: 42.088752,
    100: 42.088687,
    121: 42.088691,
    123: 42.088764,
    128: 42.08887,
    122: 42.088695,
    124: 42.088753,
    178: 42.089,
    183: 42.089209,
    181: 42.089135,
    182: 42.089149,
    184: 42.089149]
    
    /*
    var latitudes_non_numbered_rooms_and_nodes = [String: Float]()
    latitudes_non_numbered_rooms_and_nodes = [
    "Auditorium": 42.088810, //room 548
    "Bookstore": 42.089016, //room ___
    "Test Center": 42.089016, //room ___
    "SAC": 42.088991, //room 628
    "Main Entrance": 42.08857,
    ] //Science hallway
    */
 
    /////////////////LONGITUDES/////////////////
    var longitudes = [Int: Float]()
    longitudes = [001:-87.851439, //Node A
    374: -87.852061,
    370: -87.851869,
    368: -87.851869,
    366: -87.851561,
    362: -87.851353,
    360: -87.851172,
    333: -87.851333,
    331: -87.851146,
    332: -87.851146,
    339: -87.851526,
    340: -87.851654,
    341: -87.851654,
    344: -87.851818,
    345: -87.851818,
    348: -87.852029,
    349: -87.852029,
    320: -87.852065,
    316: -87.851847,
    312: -87.851643,
    304: -87.851175,
    //554
    //556
    660: -87.851313,
    665: -87.851313,
    667: -87.851313,
    669: -87.851313,
    676: -87.851313,
    678: -87.851313,
    680: -87.851313,
    682: -87.851313,
    690: -87.851313,
    548: -87.851522,
    628: -87.850982,
    626: -87.850804,
    624: -87.850749,
    //BookstoreNumber: -87.850674,
    //TestCenterNumber: -87.850595,
    605: -87.850764,
    603: -87.850764,
    621: -87.850927,
    620: -87.850802,
    625: -87.851274,
    627: -87.851413,
    616: -87.850795,
    610: -87.850648,
    609: -87.850648,
    607: -87.850648,
    198: -87.850364,
    199: -87.850364,
    197: -87.850364,
    194: -87.850364,
    195: -87.850364,
    193: -87.850364,
    190: -87.850364,
    191: -87.850364,
    160: -87.85009,
    159: -87.85009,
    158: -87.85009,
    157: -87.85009,
    156: -87.85009,
    155: -87.85009,
    154: -87.85009,
    153: -87.85009,
    152: -87.85009,
    151: -87.85009,
    120: -87.849906,
    119: -87.849906,
    118: -87.849906,
    117: -87.849906,
    116: -87.849906,
    112: -87.849906,
    111: -87.849906,
    110: -87.849906,
    109: -87.849906,
    108: -87.849906,
    107: -87.849906,
    103: -87.849913,
    101: -87.849906,
    100: -87.849906,
    121: -87.85007,
    123: -87.85007,
    128: -87.85009,
    122: -87.85009,
    124: -87.85009,
    178: -87.85037,
    183: -87.850351,
    181: -87.850351,
    182: -87.850385,
    184: -87.850385,
    ]
    
    /*
    var longitudes_non_numbered_rooms_and_nodes = [String: Float]()
    longitudes_non_numbered_rooms_and_nodes = [
    "Auditorium": -87.851522,
    "Bookstore": -87.850674,
    "Test Center": -87.850595,
    "SAC": -87.850982,
    "Main Entrance": -87.850224,
    ]
    */
    
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
    
    //Initialize each node and a list of its neighbors
    let node001 = MyNode(name: "001") //must be numbers
    let node002 = MyNode(name: "002") //the name of the node must be the same as the int used to define
    let node003 = MyNode(name: "003") //its latitude and longitude
    let node004 = MyNode(name: "004")
    let node005 = MyNode(name: "005")
    let node006 = MyNode(name: "006")
    let node007 = MyNode(name: "007")
    let node008 = MyNode(name: "008")
    let node009 = MyNode(name: "009")
    let node010 = MyNode(name: "010")
    let node374 = MyNode(name: "374")
    let node368 = MyNode(name: "368")
    let node370 = MyNode(name: "370")
    let node366 = MyNode(name: "366")
    let node362 = MyNode(name: "362")
    let node360 = MyNode(name: "360")
    let node331 = MyNode(name: "331")
    let node332 = MyNode(name: "332")
    let node333 = MyNode(name: "333")
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
    let node667 = MyNode(name: "667")
    let node669 = MyNode(name: "669")
    let node676 = MyNode(name: "676")
    let node678 = MyNode(name: "678")
    let node680 = MyNode(name: "680")
    let node682 = MyNode(name: "682")
    let node690 = MyNode(name: "690")
    let node548 = MyNode(name: "548")
    let node628 = MyNode(name: "628")
    let node626 = MyNode(name: "626")
    let node624 = MyNode(name: "624")
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
    let node178 = MyNode(name: "178")
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
    
    myGraph.add([/*node001,*/ node374, node370, node368, node366, node362, node360, node333, node331, node332, node339, node340, node341, node344, node345, node348, node349, node320, node316, node312, node304, node554, node556, node660, node665, node667, node669, node676, node678, node680, node682, node690, node548, node628, /*nodeSAC,*/ node626, node624, /*nodeBookstore, nodeTestCenter, nodeMainEntrance, */node605, node603, node621, node620, node625, node627, node616, node610, node609, node607, node198, node199, node197, node194, node195, node193, node190, node191, node160, node159, node158, node157, node156, node155, node154, node153, node152, node151, node120, node119, node118, node117, node116, node112, node111, node110, node109, node108, node107, node103, node101, node100, node121, node123, node128, node122, node124, node178, node183, node181, node182, node184, node141, node142, node140, node138, node139, node135, node133, node167, node166, node164, node162])
    /*
    func print(_ path: [GKGraphNode]) {
        path.flatMap({ $0 as? MyNode}).forEach { node in
            print(node.name)
        }
    }
 */
    
    func deg2rad(deg:Double) -> Double {
        return deg * 3.1415 / 180
    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / 3.1415
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
    
    func printCost(for path: [GKGraphNode]) {
        var total: Double = 0.0
        for i in 0..<(path.count-1) {
            total += Double(path[i].cost(to: path[i+1])) //error with override before
        }
        print("The trip is", Int(total), "feet long")
    }
    
    
    var feet:(Double, String)!
    func addNeighbors(sourceNode:MyNode, array:[MyNode]) { //used to find the weight of the path between two nodes - array is the list of neighbors
        var x:String
        x = sourceNode.getName() //get the name for the sourcenode (a room # string)
        var sourceLookupName:Int!
        sourceLookupName = Int(x)
        
        var source_longitude:Float!
        source_longitude = longitudes[sourceLookupName]
        
        var source_latitude:Float!
        source_latitude = latitudes[sourceLookupName]
        
        for node in array{ //iterate over the list of neighbors
            let y = node.getName() //get the name of the node, convert to int, and look up in lat/long dict
            var destLookupName:Int!
            destLookupName = Int(y)
            
            var dest_longitude:Float!
            dest_longitude = longitudes[destLookupName]
            
            var dest_latitude:Float!
            dest_latitude = latitudes[destLookupName]
            
            feet = (distance(lat1: Double(source_latitude), lon1: Double(source_longitude), lat2: Double(dest_latitude), lon2: Double(dest_longitude), unit: "ft"), "feet")
            sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weight
        }
    }
    
    var direction:String?
    func getDirectionOfStep (sourceNode: MyNode, destNode: MyNode) -> String {
        var x:String
        x = sourceNode.getName() //get the name for the sourcenode (a room # string)
        var sourceLookupName:Int!
        sourceLookupName = Int(x)
        
        var source_longitude:Float!
        source_longitude = longitudes[sourceLookupName]
        
        var source_latitude:Float!
        source_latitude = latitudes[sourceLookupName]
        
        let y = destNode.getName() //get the name of the node, convert to int, and look up in lat/long dict
        var destLookupName:Int!
        destLookupName = Int(y)
        
        var dest_longitude:Float!
        dest_longitude = longitudes[destLookupName]
        var dest_latitude:Float!
        dest_latitude = latitudes[destLookupName]
        
        var longitude_distance:Float!
        longitude_distance = dest_longitude-source_longitude
        var latitude_distance:Float!
        latitude_distance = dest_latitude-source_latitude
        
        if latitude_distance == 0 {
            if longitude_distance > 0{
                direction = "East"
            }
            else if longitude_distance < 0{
                direction = "West"
            }
        }
            
        else if longitude_distance == 0 {
            if latitude_distance > 0{
                direction = "North"
            }
            else if latitude_distance < 0{
                direction = "South"
            }
        }
        return direction!
    }
    
    var neighbors_dict = [MyNode: [MyNode]]()
    neighbors_dict = [node001: [node366, node362],
    node374: [node370, node368],
    node370: [node374, node366],
    node368: [node374, node366],
    node366: [node370, node368, node362, node001],
    node362: [node001, node360],
    node360: [node362],
    ]
    
    for (node,neighbors) in neighbors_dict {
    addNeighbors(sourceNode: node, array: neighbors)
    }
    
    var path = myGraph.findPath(from: node374, to: node360)
    //print("Path from room 374 to 360:")
    //print(path)
    //print(type(of: path))
    //printCost(for: path)
}
