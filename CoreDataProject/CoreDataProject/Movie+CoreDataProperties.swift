//
//  Movie+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Guilherme Flores on 18/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16

}
