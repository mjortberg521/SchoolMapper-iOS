//
//  CustomButton.swift
//  Park View
//
//  Created by Matthew Jortberg on 7/15/18.
//  Copyright © 2018 Matthew Jortberg. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    
    override open var isHighlighted: Bool {
        didSet {
            if #available(iOS 11.0, *) {
                backgroundColor = isHighlighted ? UIColor(named: "lightContinueButtonColor") : UIColor(named: "continueButtonColor") //go to a light color, then back to the original color
            } else {
                backgroundColor = isHighlighted ? UIColor(red: 0, green: 0.459, blue: 0.980, alpha: 0.5) : UIColor(red: 0, green: 0.459, blue: 0.980, alpha: 1)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
