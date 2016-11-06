//
//  ItemType+CoreDataProperties.swift
//  WishList
//
//  Created by c.uraga on 2016/09/03.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
