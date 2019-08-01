//
//  requestWebViewController.swift
//  Park View
//
//  Created by Matthew Jortberg on 7/30/18.
//  Copyright © 2018 Matthew Jortberg. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class requestWebViewController: UIViewController, SFSafariViewControllerDelegate {
    
    //@IBOutlet weak var webView: WKWebView!
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let urlString = "https://www.hackingwithswift.com"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
        
        /*
        let url = URL(string: "google.com")
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    self.webView.load(request)
                    
                } else {
                    print("ERROR: \(error)")
                }
            }
            
            task.resume()
            
        }*/
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
