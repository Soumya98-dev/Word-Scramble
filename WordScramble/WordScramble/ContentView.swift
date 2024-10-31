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
        }
        .navigationTitle(rootWord)
        .onSubmit(addNewWord)
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

}



#Preview {
    ContentView()
}
