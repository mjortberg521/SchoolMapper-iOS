//
//  settingsViewController.swift
//  Park View
//
//  Created by Matthew Jortberg on 2018-03-26.
//  Copyright © 2018 Matthew Jortberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class settingsViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var schoolNames = [String]()
    var selectedSchool = String()
    var securitySetting : Bool!
    
    let rootRef = Database.database().reference().child("Mobile")
    
    //initialize the search controller to display results at the current view
    let searchController = UISearchController(searchResultsController: nil)
    var filteredSchoolNames = [String]()
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSchoolNames = schoolNames.filter({( schoolName : String) -> Bool in
            return schoolName.lowercased().contains(searchText.lowercased())
    })
        
    tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Settings"
        print(schoolNames)
        print("loaded")
        
        //block returning to the homepage on first app launch and force user to select a school
        if UserDefaults.standard.value(forKey: "User School Name") == nil {
            self.doneButton.isEnabled = false
        } else {
            self.doneButton.isEnabled = true
        }
        
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.value(forKey: "User School Name") == nil {
            self.doneButton.isEnabled = false
        } else {
            self.doneButton.isEnabled = true
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) { //whenever the view appears, we need to reload the tableView data, which will set the checkmark correctly
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSchoolNames.count
        }
        
        else {
            return schoolNames.count
        }
    }

    //method to load the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
        
        if isFiltering() {
            cell.textLabel?.text = filteredSchoolNames[indexPath.row]
        } else {
            cell.textLabel?.text = schoolNames[indexPath.row]
        }

        var userSchoolIndexPath = IndexPath()
        
        if UserDefaults.standard.string(forKey: "User School Name") != nil { //check if a userDefault exists
            //deal with cases where a userDefault is set but that schoolName is deleted from Firebase
            
            if schoolNames.index(of: ((UserDefaults.standard.string(forKey: "User School Name")))!) != nil { //if the UserDefault string exists in our array still, check the box with that string
                
                if isFiltering() {
                    //need to check if the filtered array has the user's default school in it before generating the path to place a checkmark
                    if filteredSchoolNames.contains(UserDefaults.standard.string(forKey: "User School Name")!) {
                        userSchoolIndexPath = IndexPath(row: filteredSchoolNames.index(of: (UserDefaults.standard.string(forKey: "User School Name"))!)!, section: 0)
                    }
                    
                } else {
                    userSchoolIndexPath = IndexPath(row: schoolNames.index(of: (UserDefaults.standard.string(forKey: "User School Name"))!)!, section: 0) //get the index path for the row corresponding to our user default
                }
                
                
                if indexPath == userSchoolIndexPath { //if the cell is the one corresponding to the user default, put a checkmark next to it
                    cell.accessoryType = .checkmark
                }
                
                else {
                    cell.accessoryType = .none
                }
            }
        }
        return cell
    }
    
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToSettingsViewController(segue: UIStoryboardSegue) {
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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
        loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y/1.38)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath is the row of the view the user sees when they select something
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark { //if the user tries to reselect their current selection, do nothing
            tableView.deselectRow(at: indexPath, animated: true) //get rid of grey highlighting
        }
        
        else {
            
            if isFiltering() {
                selectedSchool = filteredSchoolNames[indexPath.row]
            }
            
            else {
                selectedSchool = schoolNames[indexPath.row]
            }
            
            //UserDefaults.standard.set(selectedSchool, forKey: "User School Name") //set user default for school name
            tableView.deselectRow(at: indexPath, animated: true) //get rid of grey highlighting
            
            print(selectedSchool)
            self.securitySetting = nil //clear the security preference before attempting to redownload since the repeat statement will close instantly if securitySetting has any value at all
            
            var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
            var container: UIView = UIView()
            
            showActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            
            DispatchQueue.global(qos: .utility).async {
                
                repeat {
                    print("fetching security setting")
                    self.doneButton.isEnabled = false
                }   while self.securitySetting == nil
                
                DispatchQueue.main.async { //this will run after schoolNames is loaded
                    self.doneButton.isEnabled = true
                    
                    print("Security preference: ", self.securitySetting)
                    
                    self.hideActivityIndicator(uiView: self.view, actInd: actInd, container: container)
                    
                    if self.securitySetting == false {
                        
                        UserDefaults.standard.set(self.selectedSchool, forKey: "User School Name") //and set the userDefault to that facility
                        
                        //flow for setting the checkmark when it doesn't transition to a password view
                        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark //check the school
                        
                        var cell = UITableViewCell()
                        var generalIndexPath = IndexPath() //must be variables to prevent it from tripping over itself...
                        
                        for i in 0..<(self.schoolNames.count) { //iterate through all of the rows in the tableView and if there are cells that have blue checks that aren't the ones just selected, make their accessory none
                            generalIndexPath = IndexPath(row: i, section: 0)
                            
                            cell = tableView.cellForRow(at: generalIndexPath)!
                            
                            if generalIndexPath != indexPath && cell.accessoryType == .checkmark { //if the current indexpath is not the one recently selected and it's accessoryType is checkmark, clear the accessory
                                cell.accessoryType = .none
                            }
                        }
                    }
                        
                    else if self.securitySetting == true {
                        self.performSegue(withIdentifier: "seguePassword", sender: self)
                    }
                }
            }
            
            //read the database for a true/false preference in the "secuirty setting" node under the selectedSchool
            self.rootRef.child(self.selectedSchool).child("Security").child("Preference").observeSingleEvent(of: .value, with: { (snapshot) in
                self.securitySetting = (snapshot.value as! Bool)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass information along
        
        if segue.identifier == "seguePassword" {
            let destViewController = segue.destination as! passwordViewController
            destViewController.selectedSchool = selectedSchool //used as nav title in next vc
        }
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension settingsViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
