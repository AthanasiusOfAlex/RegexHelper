//: Playground - noun: a place where people can play

import Cocoa
import RegexHelper

var str = "We hold these éh☺️ Truths to be self-evident"

extension String {
    
    private var dropFirst: String {
        
        if self.isEmpty {
            
            return self
            
        } else {
            
            return self[startIndex.advancedBy(1) ..< endIndex]
            
        }
        
    }
    
    private var uppercaseFirst: String {
        
        if let firstLetter = self.characters.first {
            
            return String(firstLetter).uppercaseString + self.dropFirst
            
        } else {
            
            return self
            
        }
        
    }
    
    private struct Wordifier : SequenceType {
        
        struct Generator : GeneratorType {
            
            typealias Element = String
            
            private let pattern = "([^\\s]+|\\s+)"
            private var input: String?
            
            init (input: String) {
                
                self.input = input
                
            }
            
            mutating func next() -> Element? {
                
                if let match = input?.matches(pattern).first {
                    
                    assert(match.pre=="")
                    
                    let remainder = match.post
                    
                    input = remainder=="" ? nil : remainder
                    
                    return match.hit
                    
                } else {

                    return nil
                
                }
                
            }
            
        }

        private let input: String
        
        init(input: String) {
            
            self.input = input
            
        }
        
        func generate() -> Generator {
            
            return Generator(input: input)
            
        }
        
    }
    
    // MARK - trim off any leading spaces:
    private func trimLeadingSpace(input: String) -> (String?, String) {
        
        let leadingSpace: String?
        let remainder: String
        
        if let match = input.matches("^\\s+").first {
            
            leadingSpace = match.hit
            remainder = match.post
            
        } else {
            
            leadingSpace = nil
            remainder = input
            
        }
        
        return (leadingSpace, remainder)
        
    }
    

    var titleCaseEnglishUS: String {


        // MARK - Capitalize the string and remove and leading spaces.

        let (leadingSpace, workingString) = trimLeadingSpace(self.lowercaseString)
        assert(workingString.isMatchedBy("^\\s+")==false)
        
        // MARK - turn the string into a sequence of words and spaces.
        
        let words = Wordifier(input: workingString)
        var newString: String = leadingSpace ?? ""
        let prepositionPattern = "^(a|an|the|at|by|for|in|of|on|to|up|and|as|but|or|nor)$"
        
        // MARK - go through the words and make them lowercase, if they match and
        //        are not the first word; capitalized otherwise.
        for (index, word) in words.enumerate() {
            
            if index > 0 && word.isMatchedBy(prepositionPattern, regexOptions: [.CaseInsensitive]) {
                
                newString += word.lowercaseString
                
            } else {
                
                newString += word.lowercaseString.uppercaseFirst
                
            }
            
        }
        
        return newString
        
    }

}

extension String {
    

    
}

let goo: [String] = []
goo.prefix(1)

let myStr = "a farewell to arms ".titleCaseEnglishUS

