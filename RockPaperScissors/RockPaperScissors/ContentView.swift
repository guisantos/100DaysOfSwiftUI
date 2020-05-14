//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Guilherme Flores on 14/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct AppMoves: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func appMovesStyle() -> some View {
        self.modifier(AppMoves())
    }
}

struct LabelText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.black)
    }
}

struct ContentView: View {
    @State private var moves = ["Rock", "Paper", "Scissors"].shuffled()
    @State private var shouldWin = Bool.random()
    @State private var appMove = Int.random(in: 0...2)
    @State private var totalMoves = 10
    @State private var totalScore = 0
    
    @State private var showResult = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 100) {
                HStack(spacing: 20) {
                    Text(self.moves[self.appMove])
                        .appMovesStyle()
                        .foregroundColor(.red)
                }
                
                LabelText(text: "You have to \(shouldWin ? "Win" : "Lose")")
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    ForEach(0 ..< moves.count) { number in
                        Button(action: {
                            self.checkAnswer(number)
                        }) {
                            Text(self.moves[number])
                                .appMovesStyle()
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                HStack() {
                    LabelText(text: "Plays: \(self.totalMoves)")
                        .foregroundColor(.red)
                        .padding()
                    Spacer()
                    LabelText(text: "Score: \(self.totalScore)")
                        .foregroundColor(.yellow)
                    .padding()
                }
            }
        }
        .alert(isPresented: $showResult) {
            Alert(title: Text(self.alertTitle), message: Text(self.alertMsg), dismissButton: .default(Text("Continue")) {
                    self.refreshState()
                }
            )
        }
    }
    
    func checkAnswer(_ number: Int) {
        let appMove = self.moves[self.appMove]
        let playerMove = self.moves[number]
        var shouldScore = false;
        
        if shouldWin {
            if appMove == "Paper" && playerMove == "Scissors" {
                shouldScore = true;
            }
            
            if appMove == "Rock" && playerMove == "Paper" {
                shouldScore = true;
            }
            
            if appMove == "Scissors" && playerMove == "Rock" {
                shouldScore = true;
            }
        } else {
            if appMove == "Paper" && playerMove == "Rock" {
                shouldScore = true;
            }
            
            if appMove == "Rock" && playerMove == "Scissors" {
                shouldScore = true;
            }
            
            if appMove == "Scissors" && playerMove == "Paper" {
                shouldScore = true;
            }
        }
        
        if shouldScore {
            self.totalScore += 1
            self.alertTitle = "Correct!"
            
        } else {
            self.alertTitle = "Wrong!"
        }
        
        self.totalMoves -= 1;
        
        self.alertMsg = "Left plays: \(self.totalMoves) \n Total score: \(self.totalScore)"
        
        self.showResult = true;
    }
    
    func refreshState() {
        moves.shuffle()
        appMove = Int.random(in: 0...2)
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
