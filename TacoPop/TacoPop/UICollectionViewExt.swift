//
//  UICollectionViewExt.swift
//  TacoPop
//
//  Created by c.uraga on 2016/09/11.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit


extension UICollectionView {
    func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView> (_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeReusableCell<T: UICollectionViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("fatal error")
//            return T.reuseIdentifier
        }
        return cell
    }
}

extension UICollectionViewCell: ReusableView {}
