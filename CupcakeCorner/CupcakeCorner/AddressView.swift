//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Guilherme Flores on 08/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var wrapper: OrderWrapper
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $wrapper.order.name)
                TextField("Street Address", text: $wrapper.order.streetAddress)
                TextField("City", text: $wrapper.order.city)
                TextField("Zip", text: $wrapper.order.zipcode)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(wrapper: wrapper)) {
                    Text("Check out")
                }
            }.disabled(wrapper.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(wrapper: OrderWrapper())
    }
}
