//
//  CustomSigninButton.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/06.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

class CustomSigninButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setShadows()
        layer.cornerRadius = 2.0
        
        //        layer.cornerRadius = 5.0
    }

}
