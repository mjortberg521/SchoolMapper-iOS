//
//  passwordViewController.swift
//  Park View
//
//  Created by Matthew Jortberg on 7/6/18.
//  Copyright © 2018 Matthew Jortberg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import WebKit
import SafariServices

class passwordViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate, SFSafariViewControllerDelegate {
    @IBOutlet weak var LargeTitleText: UILabel!
    @IBOutlet weak var instructionText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var requestButton: UIButton!
    //@IBOutlet weak var testTextField: UITextField!
    
    let rootRef = Database.database().reference().child("Mobile")
    
    var selectedSchool = String()
    
    var guessHash = String()
    var salt : String?
    
    var expectedPassword : String?
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var container: UIView = UIView()
    
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
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
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
    
    override func viewDidLoad() {
        
        requestButton.isEnabled = true
        requestButton.isHidden = false
        instructionText.preferredMaxLayoutWidth = 300
        instructionText.text = "Enter the access code for \(selectedSchool) to view maps"
        
        self.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //Hide the keyboard
        
        passwordTextFieldGoButtonClicked(passwordTextField) //need to pass the text field as an argument to perform the resign
        
        return true
    }
    
    func passwordTextFieldGoButtonClicked(_ textField: UITextField) {
        //this is a helper function to reorder the text field's resign
        
        if (passwordTextField.text?.count)! > 0 {
            
            self.expectedPassword = nil //set the expectedPassword variable to nil initially to allow the repeat loop/while to function
            self.salt = nil
            
            showActivityIndicator(uiView: self.view, actInd: actInd, container: container)
            
            DispatchQueue.global(qos: .utility).async {
                
                repeat {
                    print("fetching password")
                }   while self.expectedPassword == nil || self.salt == nil
                
                DispatchQueue.main.async {
                    self.guessHash = (self.salt!+self.passwordTextField.text!).sha256()
                    //print("guess hash after salt prepended")
                    //print(self.guessHash)
                    //print(self.expectedPassword)
                    
                    textField.resignFirstResponder() //take care of the resignFirstResponder here to prevent the textFieldShouldReturn method from stopping the Firebase request from running. If the text field resigns before the db request goes through, then we won't fetch the correct password
                    
                    if self.guessHash == (self.expectedPassword as! String) { //correct attempt
                        UserDefaults.standard.set(self.selectedSchool, forKey: "User School Name") //set the user default
                        
                        self.hideActivityIndicator(uiView: self.view, actInd: self.actInd, container: self.container)
                        
                        self.performSegue(withIdentifier: "unwindSegueToSettings", sender: self)
                    }
                        
                    else { //incorrect attempt
                        self.hideActivityIndicator(uiView: self.view, actInd: self.actInd, container: self.container)
                        
                        let alert = UIAlertController(title: "Incorrect password", message: "The password you entered is incorrect", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
            //fetch the hashed version of the user's password ("gotitans" is 21b4026c90ef4992e4ad481892437254c9c237eddcdd5c05b8b931230e19fa8c)
            self.rootRef.child(self.selectedSchool).child("Security").child("Code").observeSingleEvent(of: .value, with: { (snapshot) in
                self.expectedPassword = (snapshot.value as! String)
            })
            
            self.rootRef.child(self.selectedSchool).child("Security").child("Salt").observeSingleEvent(of: .value, with: { (snapshot) in
                self.salt = (snapshot.value as! String)
            })
        }
        
        else {
            let alert = UIAlertController(title: "Incorrect password", message: "The password you entered is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        passwordTextFieldGoButtonClicked(passwordTextField)
    }
    
    var webView: UIWebView!
    
    @IBAction func requestButtonClicked(_ sender: Any) {
        let urlString = "https://goo.gl/forms/sUnFFtYyd3WsV3Ka2"
        
        if let url = URL(string: urlString) {
            
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
        
    }
    
}

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
}
