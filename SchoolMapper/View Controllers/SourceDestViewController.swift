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
        let node680 = MyNode(name: "680")
        let node682 = MyNode(name: "682")
        let node690 = MyNode(name: "690")
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
        let node127 = MyNode(name: "127")
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
        let node165 = MyNode(name: "165")
        let node163 = MyNode(name: "163")
        let node161 = MyNode(name: "161")
        
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
        let node059 = MyNode(name: "059")
        let node060 = MyNode(name: "060")
        let node061 = MyNode(name: "061")
        let node062 = MyNode(name: "062")
        let node063 = MyNode(name: "063")
        let node064 = MyNode(name: "064")
        let node065 = MyNode(name: "065")
        let node066 = MyNode(name: "066")
        let node067 = MyNode(name: "067")
        let node068 = MyNode(name: "068")
        let node069 = MyNode(name: "069")
        let node070 = MyNode(name: "070")
        let node071 = MyNode(name: "071")
        let node072 = MyNode(name: "072")
        let node073 = MyNode(name: "073")
        let node074 = MyNode(name: "074")
        
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
        
        let node5001 = MyNode(name: "5001")
        let node5002 = MyNode(name: "5002")
        let node5003 = MyNode(name: "5003")
        let node5004 = MyNode(name: "5004")
        let node5005 = MyNode(name: "5005")
        let node5006 = MyNode(name: "5006")
        let node5007 = MyNode(name: "5007")
        let node5008 = MyNode(name: "5008")
        let node5009 = MyNode(name: "5009")
        let node5010 = MyNode(name: "5010")
        let node5011 = MyNode(name: "5011")
        let node5013 = MyNode(name: "5013")
        let node5015 = MyNode(name: "5015")
        let node5017 = MyNode(name: "5017")
        let node5019 = MyNode(name: "5019")
        let node5021 = MyNode(name: "5021")
        let node5012 = MyNode(name: "5012")
        let node5014 = MyNode(name: "5014")
        let node5016 = MyNode(name: "5016")
        let node5018 = MyNode(name: "5018")
        let node5020 = MyNode(name: "5020")
        let node5022 = MyNode(name: "5022")
        
        let node1001 = MyNode(name: "1001")
        let node1002 = MyNode(name: "1002")
        let node1003 = MyNode(name: "1003")
        let node1004 = MyNode(name: "1004")
        let node1005 = MyNode(name: "1005")
        let node1006 = MyNode(name: "1006")
        let node1007 = MyNode(name: "1007")
        let node1008 = MyNode(name: "1008")
        let node1009 = MyNode(name: "1009")
        let node1010 = MyNode(name: "1010")
        let node1011 = MyNode(name: "1011")
        let node1012 = MyNode(name: "1012")
        let node1013 = MyNode(name: "1013")
        let node1014 = MyNode(name: "1014")
        let node1015 = MyNode(name: "1015")
        let node1016 = MyNode(name: "1016")
        let node1017 = MyNode(name: "1017")
        let node1018 = MyNode(name: "1018")
        let node1019 = MyNode(name: "1019")
        let node1020 = MyNode(name: "1020")
        let node1021 = MyNode(name: "1021")
        let node1022 = MyNode(name: "1022")
        let node1023 = MyNode(name: "1023")
        let node1024 = MyNode(name: "1024")
        let node1025 = MyNode(name: "1025")
        let node1026 = MyNode(name: "1026")
        let node1027 = MyNode(name: "1027")
        let node1028 = MyNode(name: "1028")
        let node1029 = MyNode(name: "1029")
        let node1030 = MyNode(name: "1030")
        let node1031 = MyNode(name: "1031")
        let node1032 = MyNode(name: "1032")
        let node1033 = MyNode(name: "1033")
        
        let node222 = MyNode(name: "222")
        let node261 = MyNode(name: "261")
        let node200 = MyNode(name: "200")
        let node201 = MyNode(name: "201")
        let node202 = MyNode(name: "202")
        let node203 = MyNode(name: "203")
        let node204 = MyNode(name: "204")
        let node221 = MyNode(name: "221")
        let node224 = MyNode(name: "224")
        let node228 = MyNode(name: "228")
        let node230 = MyNode(name: "230")
        let node223 = MyNode(name: "223")
        let node206 = MyNode(name: "206")
        let node260 = MyNode(name: "260")
        let node264 = MyNode(name: "264")
        let node266 = MyNode(name: "266")
        let node268 = MyNode(name: "268")
        let node270 = MyNode(name: "270")
        let node263 = MyNode(name: "263")
        let node267 = MyNode(name: "267")
        let node269 = MyNode(name: "269")
        let node225 = MyNode(name: "225")
        let node227 = MyNode(name: "227")
        let node233 = MyNode(name: "233")
        let node235 = MyNode(name: "235")
        let node241 = MyNode(name: "241")
        let node239 = MyNode(name: "239")
        let node243 = MyNode(name: "243")
        let node245 = MyNode(name: "245")
        let node238 = MyNode(name: "238")
        let node240 = MyNode(name: "240")
        let node244 = MyNode(name: "244")
        let node246 = MyNode(name: "246")
        let node247 = MyNode(name: "247")
        let node248 = MyNode(name: "248")
        let node249 = MyNode(name: "249")
        let node252 = MyNode(name: "252")
        let node251 = MyNode(name: "251")
        let node207 = MyNode(name: "207")
        let node208 = MyNode(name: "208")
        let node209 = MyNode(name: "209")
        let node210 = MyNode(name: "210")
        let node212 = MyNode(name: "212")
        let node213 = MyNode(name: "213")
        let node214 = MyNode(name: "214")
        let node288 = MyNode(name: "288")
        let node289 = MyNode(name: "289")
        let node286 = MyNode(name: "286")
        let node285 = MyNode(name: "285")
        let node282 = MyNode(name: "282")
        let node283 = MyNode(name: "283")
        let node280 = MyNode(name: "280")
        let node278 = MyNode(name: "278")
        let node276 = MyNode(name: "276")
        let node279 = MyNode(name: "279")
        let node274 = MyNode(name: "274")
        let node277 = MyNode(name: "277")
        
        let node400 = MyNode(name: "400")
        let node401 = MyNode(name: "401")
        let node402 = MyNode(name: "402")
        let node403 = MyNode(name: "403")
        let node404 = MyNode(name: "404")
        let node408 = MyNode(name: "408")
        let node439 = MyNode(name: "439")
        let node409 = MyNode(name: "409")
        let node410 = MyNode(name: "410")
        let node411 = MyNode(name: "411")
        let node412 = MyNode(name: "412")
        let node414 = MyNode(name: "414")
        let node417 = MyNode(name: "417")
        let node441 = MyNode(name: "441")
        let node440 = MyNode(name: "440")
        let node443 = MyNode(name: "443")
        let node442 = MyNode(name: "442")
        let node444 = MyNode(name: "444")
        let node470 = MyNode(name: "470")
        let node472 = MyNode(name: "472")
        let node474 = MyNode(name: "474")
        let node476 = MyNode(name: "476")
        let node478 = MyNode(name: "478")
        let node480 = MyNode(name: "480")
        let node482 = MyNode(name: "482")
        let node484 = MyNode(name: "484")
        let node486 = MyNode(name: "486")
        let node488 = MyNode(name: "488")
        let node490 = MyNode(name: "490")
        let node492 = MyNode(name: "492")
        let node448 = MyNode(name: "448")
        let node451 = MyNode(name: "451")
        let node450 = MyNode(name: "450")
        let node453 = MyNode(name: "453")
        let node452 = MyNode(name: "452")
        let node455 = MyNode(name: "455")
        let node454 = MyNode(name: "454")
        let node457 = MyNode(name: "457")
        let node458 = MyNode(name: "458")
        let node460 = MyNode(name: "460")
        let node461 = MyNode(name: "461")
        let node462 = MyNode(name: "462")
        let node463 = MyNode(name: "463")
        let node421 = MyNode(name: "421")
        let node420 = MyNode(name: "420")
        let node423 = MyNode(name: "423")
        let node422 = MyNode(name: "422")
        let node425 = MyNode(name: "425")
        let node424 = MyNode(name: "424")
        let node426 = MyNode(name: "426")
        let node430 = MyNode(name: "430")
        let node432 = MyNode(name: "432")
        
        
        
        myGraph.add([node374, node370, node368, node366, node362, node360, node333, node331, node332, node339, node340, node341, node344, node345, node348, node349, node320, node316, node312, node304, node554, node556, node660, node665, node663, node667, node669, node661, node676, node678, node680, node682, node690, node548, node628, node626, node624, /*nodeBookstore*/ node600,  node605, node603, node621, node620, node625, node627, node616, node610, node609, node607, node198, node199, node197, node194, node195, node193, node190, node191, node160, node159, node158, node157, node156, node155, node154, node153, node152, node151, node120, node119, node118, node117, node116, node112, node111, node110, node109, node108, node107, node103, node101, node100, node121, node123, node128, node122, node124, node127, node176, node183, node181, node182, node184, node141, node142, node140, node138, node139, node135, node133, node167, node166, node164, node162, node165, node163, node161, node001, node002, node003, node004, node005, node006, node007, node008, node009, node010, node011, node012, node013, node014, node015, node016, node017, node018, node019, node020, node021, node022, node023, node024, node025, node026, node027, node028, node029, node030, node031, node032, node033, node034, node035, node036, node037, node038, node039, node040, node041, node042, node043, node044, node045, node046, node047, node048, node049, node050, node051, node052, node053, node054, node055, node056, node057, node058, node059, node060, node061, node062, node063, node064, node065, node066, node067, node068, node069, node070, node071, node072, node073, node074, node801, node711, node713, node715, node717, node712, node714, node742, node537, node720, node710, node5001, node5002, node5003, node5004, node5005, node5006, node5007, node5008, node5009, node5010, node5011, node5013, node5015, node5017, node5019, node5021, node5012, node5014, node5016, node5018, node5020, node5022, node1001, node1002, node1003, node1004, node1005, node1006, node1007, node1008, node1009, node1010, node1011, node1012, node1013, node1014, node1015, node1016, node1017, node1018, node1019, node1020, node1021, node1022, node1023, node1024, node1025, node1026, node1027, node1028, node1029, node1030, node1031, node1032, node1033, node222, node261, node200, node201, node202, node203, node204, node221, node224, node228, node230, node223, node206, node260, node264, node266, node268, node270, node263, node267, node269, node225, node227, node233, node235, node241, node239, node243, node245, node238, node240, node244, node246, node247, node248, node249, node252, node251, node207, node208, node209, node210, node212, node213, node214, node288, node289, node286, node285, node282, node283, node280, node278, node276, node279, node274, node277, node400, node401, node402, node403, node404, node408, node439, node409, node410, node411, node412, node414, node417, node441, node440, node443, node442, node444, node470, node472, node474, node476, node478, node480, node482, node484, node486, node488, node490, node492, node448, node451, node450, node453, node452, node455, node454, node457, node458, node460, node461, node462, node463, node421, node420, node423, node422, node425, node424, node426, node430, node432
            ])
        
        var feet:(Double, String)! //repairing graph
        
        func read(name: String) -> [String: AnyObject] {
            if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
                let data = try? Data(contentsOf: fileUrl) {
                if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] {
                    return result!
                }
            }
            
            return [:]
        }
        
        func addNeighbors(sourceNode:MyNode, array:[MyNode]) { //used to find the weight of the path between two nodes - array is the list of neighbors
            var latitudes_first = [String: AnyObject]()
            var latitudes_second = [String: AnyObject]()
            var longitudes_first = [String: AnyObject]()
            var longitudes_second = [String: AnyObject]()
            
            latitudes_first = read(name: "Latitudes_first") //convert to plist
            latitudes_second = read(name: "Latitudes_second")
           
            longitudes_first = read(name: "Longitudes_first")
            longitudes_second = read(name: "Longitudes_second")
            
            let x = sourceNode.getName() //get the name for the sourcenode (a room # string)
            print(x)
            
            var source_longitude:Double! //this if statement is now working-------------------------------
            var source_latitude:Double!
            
            if latitudes_first.keys.contains(x) {
                source_latitude = (latitudes_first[x])?.doubleValue
                source_longitude = (longitudes_first[x])?.doubleValue
                
                print(source_latitude)
                print(source_longitude)
            }
                
            else if latitudes_second.keys.contains(x) {
                source_latitude = (latitudes_second[x])?.doubleValue
                source_longitude = (longitudes_second[x])?.doubleValue
            }
            
            for node in array { //iterate over the list of neighbors
                let y = node.getName() //get the name of the node, convert to int, and look up in lat/long dict
                
                var dest_longitude:Double! //these must all be nested
                var dest_latitude:Double!
                
                if latitudes_first.keys.contains(y) {
                    dest_latitude = (latitudes_first[y])?.doubleValue
                    dest_longitude = (longitudes_first[y])?.doubleValue
                    
                    feet = (distance(lat1: Double(source_latitude!), lon1: Double(source_longitude!), lat2: Double(dest_latitude!), lon2: Double(dest_longitude!), unit: "ft"), "feet")
                    sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weightso
                }
                
                else if latitudes_second.keys.contains(y) {
                    dest_latitude = (latitudes_second[y])?.doubleValue
                    dest_longitude = (longitudes_second[y])?.doubleValue
                    
                    feet = (distance(lat1: Double(source_latitude!), lon1: Double(source_longitude!), lat2: Double(dest_latitude!), lon2: Double(dest_longitude!), unit: "ft"), "feet")
                    sourceNode.addConnection(to: node, weight: feet.0) //add the connection with the distance in feet as the weightso
                }
                
                                    
            }
        } //end addNeighbors
        
        //SETUP THE GRAPH
        var neighbors_dict = [MyNode: [MyNode]]()
        neighbors_dict = [node001: [node366, node362, node002],
                          node374: [node370, node368, node068],
                          node370: [node374, node366, node368],
                          node368: [node374, node366],
                          node366: [node370, node368, node362, node001],
                          node362: [node001, node360],
                          node360: [node362, node066],
                          node002: [node339, node333, node003],
                          node333: [node002, node331],
                          node331: [node333, node033],
                          node332: [node331, node333],
                          node339: [node002, node341],
                          node340: [node341, node339, node345, node344],
                          node341: [node340, node339, node345, node344],
                          node344: [node345, node340, node341, node348, node349],
                          node345: [node344, node340, node341, node348, node349],
                          node349: [node348, node344, node345, node071],
                          node348: [node349, node345, node344, node071],
                          node003: [node004, node304, node067],
                          node004: [node003, node312, node548],
                          node312: [node004, node316],
                          node316: [node312, node320],
                          node320: [node316, node073],
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
                          node008: [node009, node010, node600],
                          node010: [node008, node011, node022],
                          node011: [node176, node166, node016, node010, node5005],
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
                          node198: [node199, node194, node065],
                          node199: [node198, node197],
                          node013: [node034, node620, node616, node605],
                          node014: [node151, node152, node012, node015, node142, node141],
                          node151: [node014, node152, node153],
                          node152: [node014, node151, node154],
                          node153: [node154, node155, node151],
                          node154: [node156, node153, node152],
                          node155: [node153, node157, node156],
                          node156: [node158, node154, node155],
                          node157: [node159, node155, node158],
                          node158: [node160, node157, node156],
                          node159: [node160, node157, node061],
                          node160: [node159, node158, node061],
                          node015: [node112, node014, node116],
                          node120: [node119, node064],
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
                          node016: [node011, node017, node127, node133, node5005],
                          node017: [node103, node107],
                          node018: [node537],
                          node019: [node020, node100],
                          node020: [node019, node121, node801],
                          node121: [node122, node059],
                          node801: [node020, node021],
                          node021: [node801, node022, node161],
                          node022: [node021, node023],
                          node023: [node024, node022],
                          node024: [node023, node025],
                          node025: [node026, node024],
                          node026: [node025, node027],
                          node027: [node026, node028],
                          node028: [node027, node029],
                          node029: [node028, node030],
                          node030: [node029, node031, node032],
                          node031: [node304, node030, node5011],
                          node032: [node030, node033],
                          node033: [node032, node331, node5013],
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
                          node052: [node660, node669, node054, node678, node680, node682, node690],
                          node053: [node665, node663, node660, node661],
                          node054: [node676, node678, node052],
                          node055: [node548, node554, node004],
                          node056: [node046, node057],
                          node057: [node056, node058],
                          node058: [node057, node720, node710],
                          node059: [node020, node5001, node121],
                          node060: [node5003, node021, node161],
                          node061: [node160, node159, node5007, node062],
                          node062: [node061, node063],
                          node063: [node062, node064],
                          node064: [node063, node120],
                          node065: [node198, node5009],
                          node066: [node360, node5015],
                          node067: [node002, node003, node5021],
                          node068: [node374, node069],
                          node069: [node068, node070],
                          node070: [node069, node072, node071],
                          node071: [node070, node072, node349, node348],
                          node072: [node070, node071, node5017],
                          node073: [node320, node074],
                          node074: [node073, node5019],
                          
                          node711: [node047],
                          node713: [node049, node715],
                          node715: [node713, node717],
                          node717: [node712, node715],
                          node712: [node717, node714],
                          node714: [node742, node712],
                          node742: [node714, node049],
                          node710: [node058, node720],
                          node720: [node058, node710],
                          node141: [node142, node140],
                          node142: [node141, node014],
                          node140: [node141, node138],
                          node138: [node139, node140],
                          node139: [node138, node135],
                          node135: [node139, node133],
                          node133: [node016, node135],
                          node167: [node166, node165],
                          node166: [node011, node167],
                          node164: [node165, node163],
                          node162: [node163, node161],
                          node165: [node167, node164],
                          node163: [node164, node162],
                          node161: [node162, node021],
                          node600: [node008],
                          node660: [node667, node052, node053],
                          node665: [node053],
                          node663: [node051, node053],
                          node667: [node660, node669, node665],
                          node669: [node667, node052, node676],
                          node661: [node053],
                          node676: [node669, node054],
                          node678: [node054, node052],
                          node680: [node052],
                          node682: [node052],
                          node690: [node052],
                          node122: [node121, node124],
                          node123: [node124, node128],
                          node124: [node123, node122],
                          node128: [node127, node123],
                          node127: [node128, node016],
                          
                          node5001: [node059, node5002],
                          node5002: [node5001, node1001],
                          node5003: [node060, node5004],
                          node5004: [node1004, node5003],
                          node5005: [node016, node011, node5006],
                          node5006: [node5005, node1006, node1007],
                          node5008: [node5007, node1013],
                          node5009: [node065, node5010],
                          node5010: [node5009, node1014],
                          node5011: [node5012, node031],
                          node5013: [node033, node5014],
                          node5015: [node066, node5016],
                          node5017: [node072, node5018],
                          node5019: [node074, node5020],
                          node5021: [node067, node5022],
                          node5012: [node1018, node5011],
                          node5014: [node1020, node5013],
                          node5016: [node1023, node5015],
                          node5018: [node1032, node1033, node5017],
                          node5020: [node1028, node5019],
                          node5022: [node1021, node5021],
                          
                          node1001: [node5002, node1002, node221],
                          node1002: [node1001, node222, node1005],
                          node1003: [node1004, node261, node400],
                          node1004: [node5004, node1003, node263],
                          node1005: [node1002, node200],
                          node1006: [node5006, node270, node268],
                          node1007: [node5006, node233, node230, node1008],
                          node1008: [node204, node203, node1007],
                          node1009: [node244, node243, node239, node241],
                          node1010: [node1011, node214],
                          node1011: [node1010, node1012],
                          node1012: [node1013, node1011],
                          node1013: [node1012, node5008, node251],
                          node1014: [node5010, node288, node289],
                          node1015: [node280, node244, node278],
                          node1016: [node404, node1017],
                          node1017: [node1016, node408, node1018],
                          node1018: [node1017, node409, node5012],
                          node1019: [node439, node1020],
                          node1020: [node1019, node441, node5014],
                          node1021: [node417, node1025, node5022],
                          node1022: [node441, node470, node1023],
                          node1023: [node1022, node5016],
                          node1024: [node1025, node478, node476],
                          node1025: [node1021, node448, node444, node1024],
                          node1026: [node457, node458, node1027],
                          node1027: [node430, node426, node1026],
                          node1028: [node432, node5020],
                          node1029: [node492, node1030],
                          node1030: [node1031, node1029],
                          node1031: [node1030, node1032],
                          node1032: [node1031, node5018, node1033],
                          node1033: [node1032, node5018, node463, node462],
                          
                          node222: [node261, node1002],
                          node261: [node222, node1003],
                          node200: [node1005, node201],
                          node201: [node200, node202],
                          node202: [node201, node203],
                          node203: [node204, node202],
                          node204: [node203, node1008],
                          node221: [node1001, node223, node224],
                          node224: [node221, node223],
                          node228: [node227, node230, node225],
                          node230: [node1007, node227, node228],
                          node223: [node221, node225],
                          node206: [node204, node207],
                          node260: [node264, node263],
                          node264: [node267, node260],
                          node266: [node267, node269],
                          node268: [node269, node1006],
                          node270: [node277, node1006],
                          node263: [node260, node1004],
                          node267: [node266, node264],
                          node269: [node268, node266],
                          node225: [node227, node228, node223],
                          node227: [node228, node230, node225],
                          node233: [node1007, node235],
                          node235: [node233, node238],
                          node241: [node1009, node239, node240],
                          node239: [node1009, node241, node240],
                          node243: [node1009, node245, node246],
                          node245: [node246, node243, node247, node248],
                          node238: [node240, node235],
                          node240: [node239, node241, node238],
                          node244: [node1009, node1015],
                          node246: [node245, node243, node247, node248],
                          node247: [node248, node245, node246, node249, node252],
                          node248: [node247, node245, node246, node249, node252],
                          node249: [node252, node251, node247, node248],
                          node252: [node249, node251, node247, node248],
                          node251: [node249, node252, node1013],
                          node207: [node208, node209, node206],
                          node208: [node209, node210, node207],
                          node209: [node208, node210, node207],
                          node210: [node208, node209, node212, node213],
                          node212: [node213, node214, node210],
                          node213: [node212, node214, node210],
                          node214: [node212, node213, node1010],
                          node288: [node1014, node289, node286],
                          node289: [node1014, node288, node286],
                          node286: [node288, node289, node285],
                          node285: [node286, node282, node283],
                          node282: [node283, node285, node280],
                          node283: [node282, node285, node280],
                          node280: [node1015, node282, node283],
                          node278: [node1015, node276],
                          node276: [node278, node279],
                          node279: [node276, node274],
                          node274: [node277, node279],
                          node277: [node274, node270],
                          node400: [node1003, node401],
                          node401: [node400, node402],
                          node402: [node401, node403],
                          node403: [node402, node404],
                          node404: [node403, node1016],
                          node408: [node1017, node439],
                          node439: [node408, node1019],
                          node409: [node1018, node410],
                          node410: [node409, node411],
                          node411: [node410, node412],
                          node412: [node414, node411],
                          node414: [node412, node417],
                          node417: [node1021, node414, node421],
                          node441: [node1020, node1022, node440],
                          node440: [node441, node443],
                          node443: [node440, node442],
                          node442: [node443, node444],
                          node444: [node442, node1025],
                          node470: [node1022, node472],
                          node472: [node470, node474],
                          node474: [node472, node476],
                          node476: [node1024, node474],
                          node478: [node1024, node480],
                          node480: [node478, node482],
                          node482: [node480, node484],
                          node484: [node486, node482],
                          node486: [node484, node488],
                          node488: [node486, node490],
                          node490: [node488, node492],
                          node492: [node1029, node490],
                          node448: [node1025, node451],
                          node451: [node448, node450],
                          node450: [node451, node453],
                          node453: [node450, node452],
                          node452: [node453, node455],
                          node455: [node452, node454],
                          node454: [node455, node457],
                          node457: [node1026, node454],
                          node458: [node1026, node460, node461],
                          node460: [node458, node463, node462, node461],
                          node461: [node458, node463, node462, node460],
                          node462: [node463, node1033, node460, node461],
                          node463: [node462, node1033, node460, node461],
                          node421: [node417, node420],
                          node420: [node421, node423],
                          node423: [node420, node422],
                          node422: [node423, node425, node424],
                          node425: [node424, node422, node426],
                          node424: [node425, node422, node426],
                          node426: [node425, node424, node1027],
                          node430: [node1027, node432],
                          node432: [node1028, node430],
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
    
    func read(name: String) -> [String: AnyObject] {
        if let fileUrl = Bundle.main.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: AnyObject] {
                return result!
            }
        }
        
        return [:]
    }
    var destinationName = String()
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
            
            var latitudes_first = [String: AnyObject]()
            var latitudes_second = [String: AnyObject]()
            var longitudes_first = [String: AnyObject]()
            var longitudes_second = [String: AnyObject]()
            
            
            func makeRoutePoints(array:[GKGraphNode]) { //takes path as the argument, creates an array of string lat/long coords from plist
                let fileManager = FileManager.default
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                
                array.flatMap({ $0 as? MyNode}).forEach { node in //iterate through the routePath
                    
                    let z = node.getName() //name is used to lookup lat/long
                    
                    var nodeLatitude:Double!
                    var nodeLongitude:Double!
                    
                    latitudes_first = read(name: "Latitudes_first") //convert to plist
                    latitudes_second = read(name: "Latitudes_second")
                    longitudes_first = read(name: "Longitudes_first")
                    longitudes_second = read(name: "Longitudes_second")
                    
                    
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
                
                if firstFloorPoints.isEmpty == false && secondFloorPoints.isEmpty == true {
                    movement = "first"
                    destinationName = firstFloorPath[firstFloorPath.count-1].getName()
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
        DestViewController.destinationName = destinationName
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
