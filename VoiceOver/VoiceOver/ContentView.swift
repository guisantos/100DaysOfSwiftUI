//
//  ContentView.swift
//  VoiceOver
//
//  Created by Guilherme Flores on 02/07/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var estimate = 25.0
    
    var body: some View {
        Slider(value: $estimate, in: 0...50)
        .padding()
        .accessibility(value: Text("\(Int(estimate))"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
