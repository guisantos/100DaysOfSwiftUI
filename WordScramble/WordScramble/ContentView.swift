//
//  ContentView.swift
//  WordScramble
//
//  Created by Guilherme Flores on 18/05/2020.
//  Copyright © 2020 i3pt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    class Points {
        var word: String
        var points: Int
        
        init(word: String) {
            self.word = word
            self.points = 0
        }
    }
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var pointsByWords = [Points]()

    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                List {
                    Section(header: Text("Words")) {
                        if usedWords.count == 0 {
                            Text("-")
                        }
                        ForEach(usedWords, id: \.self) { word in
                            Text("\(word) - \(word.count)")
                            .accessibility(label: Text("Word \(word) worthy \(word.count) points"))
                        }
                    }
                    Section(header: Text("Score by words")) {
                        ForEach(pointsByWords.sorted(by: {$0.points > $1.points}), id: \.word) { points in
                            Text("\(points.word) - \(points.points)")
                            .accessibility(label: Text("Word \(points.word) with total points of \(points.points)"))
                        }
                    }
                }
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(
                leading:
                    Button(action: startGame) {
                        Image(systemName: "plus.circle")
                }.accessibility(label: Text("New word")),
                trailing:
                    Button("Clear", action: clearGame)
                .accessibility(label: Text("Clear game"))
            )
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                pointsByWords.append(Points(word: rootWord))
                usedWords.removeAll()
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func clearGame() {
        pointsByWords.removeAll()
        startGame()
    }
    
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespaces)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used alread", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't jut mae them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
        pointsByWords.last?.points += answer.count
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        if word.utf16.count <= 2 {
            return false
        }
        
        if word == rootWord {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true;
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
