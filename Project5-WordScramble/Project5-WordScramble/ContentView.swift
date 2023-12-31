//
//  ContentView.swift
//  Project5-WordScramble
//
//  Created by Ayşıl Simge Karacan on 8.07.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var numberOfWords = 0
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Number of words: \(numberOfWords)")
                    Text("Score: \(score)")
                } header: {
                    Text("Your Score")
                }
    
                
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.large)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role:.cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem {
                    Button("Restart") {
                        startGame()
                        score = 0
                        numberOfWords = 0
                        usedWords.removeAll()
                    }
                }
            }
        }
        
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        // lowercase and trim the word, to make sure we don't add duplicate words with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already or same with root word", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        // Disallow answers that are shorter than three letters.
        if isShort(word: answer) {
            wordError(title: "Word is too short", message: "The word should contain more than 3 letters")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        // Update score values
        numberOfWords += 1
        score += newWord.count
        
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        // Disallow answers that are used or are just our start word.
        !usedWords.contains(word) && word != rootWord
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
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
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
        
        newWord = ""
    }
    
    func isShort(word: String) -> Bool {
        word.count <= 3
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
