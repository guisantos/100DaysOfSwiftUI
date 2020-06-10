//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Guilherme Flores on 09/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var wrapper: OrderWrapper
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = ""
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.wrapper.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(alertTitle), message: Text(confirmationMessage), dismissButton: .default(Text("Ok")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(wrapper.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {data, respons, error in
            guard let data = data else {
                self.confirmationMessage = "Connection appears to be offline, try again later"
                self.alertTitle = "Error"
                self.showingConfirmation = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your data for \(decodedOrder.quantity)x \(OrderWrapper.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.alertTitle = "Thank You!"
                self.showingConfirmation = true
            } else {
                self.confirmationMessage = "Invalid response from the server, try again later"
                self.alertTitle = "Error"
                self.showingConfirmation = true
            }
            
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(wrapper: OrderWrapper())
    }
}
