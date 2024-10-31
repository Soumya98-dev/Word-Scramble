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
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Enter your word" ,text:$newWord)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    ForEach(usedWords, id:\.self){word in
                        HStack{
                            Image(systemName:"\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .navigationTitle(rootWord)
        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
    }
    /*
    1. Lowercase newWord and remove any whitesapce
    2. Check if newWord to be added have atleast 1 charac otherwise exit
    3. Insert that word at position 0 in the usedWords array
    4. Set newWord to an empty strings
    */
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {return}
        
        withAnimation{
            usedWords.insert(answer, at:0)
        }
        
        newWord = ""
        
    }
    /*
     1. Find start.txt in my bundle
     2. Load it into a string
     3. Split that string into array of strings with each element being one word
     4. Pick one random default to be added to the rootWord; or default if array -> empty
     */
    func startGame(){
        if let startsWordURL = Bundle.main.url(forResource: "start", withExtension:"txt"){
            if let startWords = try? String(contentsOf: startsWordURL, encoding: .utf8){
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkWorm"
                print("Loaded root word: \(rootWord)")
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle")
    }

}



#Preview {
    ContentView()
}
