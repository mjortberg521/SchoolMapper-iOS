//  Copyright © 2018 Matthew Jortberg. All rights reserved.

import Foundation
import UIKit

class StepsViewController: UITableViewController {

    // MARK: - UITableViewDataSource
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Distance"
    }
    
    var distanceInFeet = Int()
    lazy var displayDistanceInFeet = String(distanceInFeet)+" feet"
    
    lazy var distanceInMeters : Int = Int(Float(distanceInFeet)*0.3048)
    lazy var displayDistanceInMeters = String(distanceInMeters)+" meters"
    
    lazy var steps = [displayDistanceInFeet, displayDistanceInMeters]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    //var steps = [displayDistance]
    //var steps = ["left"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) //identifier is LabelCell in IB
        
        cell.textLabel?.text = steps[indexPath.row]
        
        return cell
    }
}
