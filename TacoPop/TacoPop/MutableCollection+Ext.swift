//
//  MutableCollection+Ext.swift
//  TacoPop
//
//  Created by c.uraga on 2016/09/11.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation

extension MutableCollection where Index == Int { // any mutable collection that has an integer index
    mutating func shuffle () {
        if count < 2 {
            return
        }
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
