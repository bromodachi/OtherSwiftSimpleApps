//
//  ImageCircleView.swift
//  SocialNetwork
//
//  Created by c.uraga on 2016/11/13.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

class ImageCircleView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews(){
        super.layoutSubviews()
        createCircleOfView()
        clipsToBounds = true
    }

}
