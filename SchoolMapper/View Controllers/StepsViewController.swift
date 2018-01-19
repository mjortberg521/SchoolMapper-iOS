//
//  StepsViewController.swift
//  Park View
//
//  Created by Matthew Jortberg on 2017-12-28.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

class StepsViewController: UITableViewController {

    // MARK: - UITableViewDataSource
    
    var distanceInFeet = Int()
    lazy var displayDistanceInFeet = String(distanceInFeet)+" feet"
    
    lazy var distanceInMeters : Int = Int(Float(distanceInFeet)*0.3048)
    lazy var displayDistanceInMeters = String(distanceInMeters)+" meters"
    
    lazy var steps = [displayDistanceInFeet, displayDistanceInMeters]
    
    override func viewDidLoad() {
        navigationItem.title = "Steps"
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
