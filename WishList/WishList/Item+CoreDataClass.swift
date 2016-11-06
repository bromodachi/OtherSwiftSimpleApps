//
//  Item+CoreDataClass.swift
//  WishList
//
//  Created by c.uraga on 2016/09/03.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        //when inserted into the NSContent
        super.awakeFromInsert()
        self.created = NSDate() //create the current date and set it
    }

}
