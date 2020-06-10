//
//  Order.swift
//  CupcakeCorner
//
//  Created by Guilherme Flores on 09/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import Foundation

class OrderWrapper: ObservableObject {
    @Published var order = Order()
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var hasValidAddress: Bool {
        if order.name.trimmingCharacters(in: .whitespaces).isEmpty || order.streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || order.city.trimmingCharacters(in: .whitespaces).isEmpty || order.zipcode.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Double {
        var cost = Double(order.quantity) * 2
        cost += Double(order.type) / 2
        
        if order.extraFrosting {
            cost += Double(order.quantity)
        }
        
        if order.addSprinkles {
            cost += Double(order.quantity) / 2
        }
        
        return cost
    }
}
