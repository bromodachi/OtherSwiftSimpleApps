//
//  Constants.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/06.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
extension UIView {
    func setShadows(){
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0 // how far the shadow stretches out
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0) //Goes one pixel to the left and right. Height from
        layer.cornerRadius = 2.0
    }
    
    func createCircleOfView(){
        layer.cornerRadius =  self.frame.width / 2
    }
}

let SHADOW_GRAY: CGFloat = 120.0 / 255.0


let uniqueServiceName = "Uraga.SocialNetwork"
let uniqueAccessGroup = "sharedAccessGroupName"
let KEY_UID = "uid"
let BASE_URL = "https://socialnetwork-71e0a.firebaseio.com/"
