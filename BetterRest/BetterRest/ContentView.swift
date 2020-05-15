//
//  ContentView.swift
//  BetterRest
//
//  Created by Guilherme Flores on 15/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTIme
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var calculatedBedTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
                model.prediction(
                    wake: Double(hour + minute),
                    estimatedSleep: sleepAmount,
                    coffee: Double(coffeeAmount))
            
            let sleeptTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleeptTime)
        } catch {
            return "00:00"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    
                    Text("\(calculatedBedTime)")
                        .font(.system(size: 50, weight: .black))
                        .foregroundColor(.blue)
                    Text("Sleep Time")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .bold()
                }
                
                Form {
                    Section(header: Text("When do want to wake up?")
                                        .font(.headline)) {
                        DatePicker("Please enter a time",
                                   selection: $wakeUp,
                                   displayedComponents: .hourAndMinute)
                        .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    Section(header: Text("Disered amount of sleep")
                                        .font(.headline)) {
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                    
                    Section(header: Text("Daily coffee intake")
                                        .font(.headline)) {
                        Picker("Cups", selection: $coffeeAmount) {
                            ForEach(0 ..< 20) {
                                Text("\($0) \($0 < 2 ? "Cup" : "Cups")")
                            }
                        }.pickerStyle(DefaultPickerStyle())
                    }
                }
                .navigationBarTitle("BetterRest")
            }
        }
    }
    
    static var defaultWakeTIme: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
