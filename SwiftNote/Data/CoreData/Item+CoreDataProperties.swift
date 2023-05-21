//
//  Item+CoreDataProperties.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 21/05/2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double

}

extension Item : Identifiable {

}
