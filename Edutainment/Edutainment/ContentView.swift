//
//  ContentView.swift
//  Edutainment
//
//  Created by Guilherme Flores on 22/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct Question {
    var n1: Int
    var n2: Int
    
        init(n1: Int, n2: Int) {
            self.n1 = n1
            self.n2 = n2
        }
}

struct WhiteStrokeSquare: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(3)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
    }
}

extension View {
    func whiteStrokeSquareStyle() -> some View {
        self.modifier(WhiteStrokeSquare())
    }
}

struct ContentView: View {
    @State private var settings = true
    @State private var rows = [1 ..< 7, 7 ..< 13]
    @State private var selectedNumbers: [Int] = []
    
    @State private var amountOfQuestions = ["5", "10", "20", "All"]
    @State private var selectedAmount = 0
    
    @State private var buttonAnimation: CGFloat = 0
    @State private var wrongAnimation: Double = 0
    @State private var rotation = 0.0
    
    @State private var questions: [Question] = []
    @State private var numberQuestion = 1
    @State private var score = 0
    
    @State private var answer = ""
    
    @State private var showEnd = false
    @State private var alertMsg = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemTeal)
                    .edgesIgnoringSafeArea(.all)
                if settings {
                    VStack {
                        Section {
                            Text("Select tables and amount of questions to start!")
                                .font(.title)
                                .foregroundColor(.white)
                                .bold()
                                .fontWeight(.black)
                                .padding(20)
                                .multilineTextAlignment(.center)
                        }
                        Section {
                            ForEach(0 ..< 2) { n in
                                HStack {
                                    ForEach(self.rows[n]) { number in
                                        Button(action: {
                                            withAnimation {
                                                self.selectNumber(number);
                                            }
                                        }) {
                                            Text("\(number)")
                                                .font(.title)
                                                .frame(width: 50, height: 50)
                                                .background(self.selectedNumbers.contains(number) ? Color.blue : Color.red)
                                                .whiteStrokeSquareStyle()
                                                .scaleEffect(self.selectedNumbers.contains(number) ? 1.1 : 1)
                                                
                                        }
                                    }
                                }.padding(5)
                            }
                            Text("Select the multiplication tables")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .bold()
                        }
                        
                        Section {
                            HStack {
                                ForEach(0 ..< amountOfQuestions.count) { number in
                                    Button(action: {
                                        withAnimation {
                                            self.selectAmount(number);
                                        }
                                    }) {
                                        Text("\(self.amountOfQuestions[number])")
                                            .font(.title)
                                            .frame(width: 50, height: 50)
                                            .background(self.selectedAmount == number ? Color.blue : Color.yellow)
                                            .whiteStrokeSquareStyle()
                                            .scaleEffect(self.selectedAmount != number ? 1 : 1.1)
                                    }
                                }
                            }.padding(.top)
                            .padding(5)
                            
                            Text("Select the amount of questions")
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .bold()
                        }
                        
                        Spacer()
                        
                        Section {
                            Button(action: {
                                self.calculateAndStart()
                            }) {
                                Text("Start!")
                                    .font(.title)
                                    .frame(width: 200, height: 100)
                                    .background(self.selectedNumbers.count == 0 ? Color.gray : Color.green)
                                    .whiteStrokeSquareStyle()
                                    .scaleEffect(self.selectedNumbers.count == 0 ? 1 : 1.1).animation(.default)
                                    .shadow(radius: 4)
                            }
                        }.padding(.top)
                        .padding(20)
                            .rotation3DEffect(.degrees(self.wrongAnimation), axis: (x: 0, y: 0, z: 1))
                        
                        Spacer()
                    }
                } else {
                    VStack(alignment: .center) {
                        Section {
                            VStack {
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading) {
                                        Section {
                                            Text("\(numberQuestion) - \(questions.count)")
                                            .font(.system(size: 30, weight: .black))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Section {
                                            Text("Score: \(score)")
                                            .font(.system(size: 30, weight: .black))
                                            .foregroundColor(.white)
                                        }
                                    }
                                }
                                HStack(alignment: .center) {
                                    Text("\(questions[numberQuestion - 1].n1)")
                                        .font(.system(size: 80, weight: .black))
                                        .foregroundColor(.white)
                                    Text("X")
                                        .font(.system(size: 40, weight: .black))
                                        .foregroundColor(.white)
                                    Text("\(questions[numberQuestion - 1].n2)")
                                        .font(.system(size: 80, weight: .black))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(10)
                            .background(Color.red)
                            .whiteStrokeSquareStyle()
                        }
                        .padding(.horizontal)
                        
                        Section {
                                TextField("Answer", text: $answer)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 80, weight: .black))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    
                            
                                Button(action: {
                                    self.checkAnswer()
                                }) {
                                    Text("Answer!")
                                        .font(.title)
                                        .frame(width: 200, height: 100)
                                        .background(self.answer.isEmpty ? Color.gray : Color.green).animation(.default)
                                        .whiteStrokeSquareStyle()
                                        .scaleEffect(self.answer.isEmpty ? 1 : 1.1).animation(.default)
                                }
                                .rotation3DEffect(.degrees(self.wrongAnimation), axis: (x: 0, y: 0, z: 1))
                                .rotation3DEffect(.degrees(self.rotation), axis: (x: 0, y: 1, z: 0))
                            }
                        
                        Spacer()
                    }
                }
            }.navigationBarTitle(
                Text("Edutainment")
            )
            .alert(isPresented: $showEnd) {
                Alert(title: Text("Final Results"), message: Text(self.alertMsg), dismissButton: .default(Text("Continue")) {
                        self.resetGame()
                    })
            }
        }
    }
    
    func selectNumber(_ number: Int) {
        if let unwrapped = selectedNumbers.firstIndex(of: number) {
            selectedNumbers.remove(at: unwrapped)
        } else {
            selectedNumbers.append(number)
        }
    }
    
    func selectAmount(_ number: Int) {
        selectedAmount = number
    }
    
    func calculateAndStart() {
        if selectedNumbers.count == 0 {
            withAnimation(Animation.interpolatingSpring(mass: 0.5, stiffness: 120, damping: 5, initialVelocity: 700)) {
                self.wrongAnimation = 1
            }
            self.wrongAnimation = 0
        } else {
            if let amount = Int(amountOfQuestions[selectedAmount]) {
                for _ in 0 ..< amount {
                    if let n1 = selectedNumbers.randomElement() {
                        let n2 = Int.random(in: 1...10)
                        self.questions.append(Question(n1: n1, n2: n2))
                    }
                }
            } else {
                for number in selectedNumbers {
                    for n2 in 1...10 {
                        self.questions.append(Question(n1: number, n2: n2))
                    }
                }
            }
            self.questions.shuffle()
            
            withAnimation {
                self.settings = false
            }
        }
    }
    
    func checkAnswer() {
        if self.answer.isEmpty {
            withAnimation(Animation.interpolatingSpring(mass: 0.5, stiffness: 120, damping: 5, initialVelocity: 700)) {
                self.wrongAnimation = 1
            }
            self.wrongAnimation = 0
        } else {
            if let amount = Int(answer) {
                let n1 = questions[numberQuestion - 1].n1
                let n2 = questions[numberQuestion - 1].n2
                
                if amount == n1 * n2 {
                    self.score += 1
                    
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
                        self.rotation = 360
                    }
                    self.rotation = 0
                } else {
                    withAnimation(Animation.interpolatingSpring(mass: 0.5, stiffness: 120, damping: 5, initialVelocity: 700)) {
                        self.wrongAnimation = 1
                    }
                    self.wrongAnimation = 0
                }
                
                if self.numberQuestion != questions.count {
                    self.numberQuestion += 1
                    self.answer = ""
                } else {
                    self.showEnd = true
                    self.alertMsg = "Your final score is \(self.score) out of \(self.questions.count)"
                }
            }
        }
    }
    
    func resetGame() {
        self.settings = true;
        self.answer = ""
        self.numberQuestion = 1
        self.score = 0
        self.questions = []
        self.selectedNumbers = []
        self.selectedAmount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
