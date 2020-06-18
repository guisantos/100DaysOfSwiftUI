//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Guilherme Flores on 18/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//
//

import Foundation
import CoreData


extension Candy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

    public var wrappedName: String {
        name ?? "Unknown Candy"
    }
}
