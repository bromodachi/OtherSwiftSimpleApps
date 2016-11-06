//
//  NibLoadableView.swift
//  TacoPop
//
//  Created by c.uraga on 2016/09/11.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

protocol NibLoadableView:class {
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }

}
