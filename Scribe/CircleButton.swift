//
//  CircleButton.swift
//  Scribe
//
//  Created by c.uraga on 2016/09/13.
//  Copyright © 2016年 c.uraga. All rights reserved.
//


import UIKit
@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet{
            setupVIew ()
        }
        
    }
    
    override func prepareForInterfaceBuilder() {
        setupVIew ()
        
    }
    
    func setupVIew () {
        layer.cornerRadius = cornerRadius
    }
}
