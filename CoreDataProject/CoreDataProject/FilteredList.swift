//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Guilherme Flores on 18/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//
import CoreData
import SwiftUI

enum Predicates {
    case beginsWith
    case like
    case contains
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) {
            singer in
            self.content(singer)
        }
    }
    
    init(filterKey: String, filterValue: String, enumPredicate: Predicates, sort: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        var predicate = ""
        
        switch enumPredicate {
            case .beginsWith:
                predicate = "BEGINSWITH"
            case .like:
                predicate = "LIKE"
            case .contains:
                predicate = "CONTAINS[c]"
        }
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sort, predicate: NSPredicate(format: "%K \(predicate) %@", filterKey, filterValue))
        self.content = content
    }
}
