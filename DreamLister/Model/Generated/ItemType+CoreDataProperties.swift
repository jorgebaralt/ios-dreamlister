//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Jorge Baralt on 11/24/18.
//  Copyright © 2018 Jorge Baralt. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
