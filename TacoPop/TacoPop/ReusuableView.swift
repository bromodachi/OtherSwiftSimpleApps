//
//  ReusuableView.swift
//  TacoPop
//
//  Created by c.uraga on 2016/09/11.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

protocol ReusableView : class {
    
}

extension ReusableView where Self:UIView {
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}
