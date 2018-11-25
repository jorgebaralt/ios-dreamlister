//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Jorge Baralt on 11/24/18.
//  Copyright © 2018 Jorge Baralt. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
}
