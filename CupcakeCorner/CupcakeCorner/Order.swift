//
//  OrderStruct.swift
//  CupcakeCorner
//
//  Created by Guilherme Flores on 10/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import Foundation

struct Order: Codable {
    var type = 3
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zipcode = ""
}
