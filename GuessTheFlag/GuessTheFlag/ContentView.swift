//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Guilherme Flores on 11/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var opacities = [1.0, 1.0 ,1.0]
    @State private var degrees = [0.0, 0.0, 0.0]
    @State private var wrongDegrees: [Double] = [0, 0, 0]
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var alertMessage = ""

    struct FlagImage: View {
        var image: String
        var opacity: Double
        
        var body: some View {
            Image(image)
                .renderingMode(.original)
                .clipShape(Capsule())
                    .overlay(Capsule()
                    .stroke(Color.black, lineWidth: 3))
                .shadow(radius: 2)
                .opacity(opacity)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    VStack{
                    Button(action: {
                        self.flagTapped(number)
                        withAnimation {
                            if number == self.correctAnswer {
                                    self.degrees[number] += 360
                                    if number == 0 {
                                        self.opacities[1] -= 0.75
                                        self.opacities[2] -= 0.75
                                    } else if number == 1 {
                                        self.opacities[2] -= 0.75
                                        self.opacities[0] -= 0.75
                                    } else if number == 2 {
                                        self.opacities[0] -= 0.75
                                        self.opacities[1] -= 0.75
                                    }
                            } else {
                                withAnimation(Animation.interpolatingSpring(mass: 1, stiffness: 120, damping: 5, initialVelocity: 700)) { // challenge 3 day 34
                                    self.wrongDegrees[number] = 1
                                }
                            }
                        }
                        }) {
                            FlagImage(
                                image: self.countries[number],
                                opacity: self.opacities[number])
                        }
                    }.rotation3DEffect(.degrees(self.degrees[number]), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(self.wrongDegrees[number]), axis: (x: 0, y: 0, z: 1))
                }
                
                Text("Score \(currentScore)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(self.scoreTitle), message: Text(self.alertMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                    self.resetAnimations()
                })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
            alertMessage = "Your score is \(currentScore)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetAnimations() {
        self.opacities = [1.0, 1.0 ,1.0]
        self.degrees = [0.0, 0.0, 0.0]
        self.wrongDegrees = [0, 0, 0]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
