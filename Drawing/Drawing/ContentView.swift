//
//  ContentView.swift
//  Drawing
//
//  Created by Guilherme Flores on 03/06/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endpoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, to: endpoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
}

struct Arrow: InsettableShape {
    
    var amount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width / 2, y: 0))
        path.addLine(to: CGPoint(x: amount, y: rect.height / 3))
        path.addLine(to: CGPoint(x: rect.width - amount, y: rect.height / 3))
        path.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        
        path.addRect(CGRect(x: rect.width / 4 + amount, y: rect.height / 3, width: rect.width / 2 - amount * 2, height: rect.height / 3 * 2))
        
        return path
    }
    
    func inset(by amount: CGFloat) -> Arrow {
        var arrow = self
        arrow.amount = amount
        return arrow
    }
    
    var animatableData: CGFloat {
        get { self.amount }
        set { self.amount = newValue }
    }
}

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                RoundedRectangle(cornerRadius: 10)
                .inset(by: CGFloat(value))
                .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6
    
    @State private var colorCycle = 0.0
    @State private var arrowThickness = 0.0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Arrow(amount: CGFloat(arrowThickness))
                    .fill(Color.red, style: FillStyle(eoFill: false))
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        withAnimation {
                            if self.arrowThickness == 0 {
                                self.arrowThickness = 40
                            } else {
                                self.arrowThickness = 0
                            }
                        }
                }
                
                VStack {
                    ColorCyclingCircle(amount: self.colorCycle)
                        .frame(width: 300, height: 300)

                    Slider(value: $colorCycle)
                        .padding(.horizontal)
                    
                    ColorCyclingRectangle(amount: self.colorCycle)
                    .frame(width: 300, height: 300)
                }

                VStack(spacing: 0) {
                    Spacer()
                    
                    Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                    .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                        .frame(width: 300, height: 300)
                    
                    Spacer()
                    
                    Group {
                        Text("Inner radius: \(Int(innerRadius))")
                        Slider(value: $innerRadius, in: 10...150, step: 1)
                            .padding([.horizontal, .bottom])
                        
                        Text("Outer radius: \(Int(outerRadius))")
                        Slider(value: $outerRadius, in: 10...150, step: 1)
                            .padding([.horizontal, .bottom])
                        
                        Text("Distance: \(Int(distance))")
                        Slider(value: $distance, in: 10...150, step: 1)
                            .padding([.horizontal, .bottom])
                        
                        Text("Amount: \(amount, specifier: "%.2f")")
                        Slider(value: $amount)
                            .padding([.horizontal, .bottom])
                        
                        Text("Color")
                        Slider(value: $hue)
                            .padding(.horizontal)
                        
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
