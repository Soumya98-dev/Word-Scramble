//
//  ContentView.swift
//  WordScramble
//
//  Created by Soumyadeep Chatterjee on 10/29/24.
//

import SwiftUI

struct ContentView: View {

    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""

    //For showing error alerts
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
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
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Start new Game"){
                        startGame()
                    }
                }
            }

        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {
            Button("Ok") {}
        } message: {
            Text(errorMessage)
        }
    }

    /*
    1. Lowercase newWord and remove any whitesapce
    2. Check if newWord to be added have atleast 1 charac otherwise exit
    3. Insert that word at position 0 in the usedWords array
    4. Set newWord to an empty strings
    */
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(
            in: .whitespacesAndNewlines)
        
        guard answer.count > 2 else {
            wordError(title: "New word should be greater than 2", message: "")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Can't be same like the start word", message: "")
            return
        }
        
//        newWord = ""
        
        guard isOriginal(word:answer) else{
            wordError(title: "Word Used Already", message:"Be more original")
            return
        }
        
        guard isPossible(word:answer) else{
            wordError(title: "Word not possible", message: "You cannot spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else{
            wordError(title: "Word not recognized", message: "you cannot just make them up")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }

    }
    /*
     1. Find start.txt in my bundle
     2. Load it into a string
     3. Split that string into array of strings with each element being one word
     4. Pick one random default to be added to the rootWord; or default if array -> empty
     */
    func startGame() {
        if let startsWordURL = Bundle.main.url(
            forResource: "start", withExtension: "txt")
        {
            if let startWords = try? String(
                contentsOf: startsWordURL, encoding: .utf8)
            {
                let allWords = startWords.components(separatedBy: "\n")

                rootWord = allWords.randomElement() ?? "silkWorm"
                print("Loaded root word: \(rootWord)")
                return
            }
        }

        fatalError("Could not load start.txt from bundle")
    }

    //Checking if the word has not been used before
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }

    //Checking if the word is possible
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            //this gets the first index of the letter we type from the rootword
            if let pos = tempWord.firstIndex(of: letter) {
                //print(pos)
                //remove the word
                tempWord.remove(at: pos)
                //print(tempWord)
            } else {
                return false
            }
        }

        return true
    }

    //Scanning Strings for mispelled words
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()

        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    //for showing the errors
    func wordError(title:String, message:String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }

}

#Preview {
    ContentView()
}
