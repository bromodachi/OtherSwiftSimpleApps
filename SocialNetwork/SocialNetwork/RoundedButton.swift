//
//  RoundedButton.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/06.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setShadows()
        
//        layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createCircleOfView()
    }
    

}
