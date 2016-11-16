//
//  CustomTabBarItem.swift
//  CustomTabBar
//
//  Created by c.uraga on 2016/11/16.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit


class CustomTabBarItem: UIView {

    var iconView: UIImageView!
    
    var label: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initalTabBarItemIndex = 1
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: UITabBarItem){
        guard let image = item.image else {
            return
        }
        
        iconView = UIImageView(frame: CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height / 2))
        
        label = UILabel(frame: CGRect(x: self.frame.width  / 2, y: self.frame.height - 20, width: self.frame.width, height: 20))
        label.text = "1"
        
        iconView.image = image
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = UIColor.black
        
        self.addSubview(iconView)
        self.addSubview(label)
        
    }
    
    
}
