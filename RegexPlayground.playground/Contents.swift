//: Playground - noun: a place where people can play

import Cocoa
import RegexHelper

var str = "We hold these éh☺️ Truths to be self-evident"

extension String {
    
    private func dropFirst() -> String {
        
        if self.isEmpty {
            
            return self
            
        } else {
            
            return self[self.index(self.startIndex, offsetBy: 1) ..< self.endIndex]
            
        }
        
    }
    
    private func firstLetterUppercased() -> String {
        
        if let firstLetter = self.characters.first {
            
            return String(firstLetter).uppercased() + self.dropFirst()
            
        } else {
            
            return self
            
        }
        
    }
    
    private struct Wordifier : Sequence {
        
        struct Iterator : IteratorProtocol {
            
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
        
        func makeIterator() -> Iterator {
            
            return Iterator(input: input)
            
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
    

    func titleCasedAsEnglishUS() -> String {

        // MARK - Capitalize the string and remove and leading spaces.

        let (leadingSpace, workingString) = trimLeadingSpace(input: self.lowercased())
        assert(workingString.isMatchedBy("^\\s+")==false)
        
        // MARK - turn the string into a sequence of words and spaces.
        
        let words = Wordifier(input: workingString)
        var newString: String = leadingSpace ?? ""
        let prepositionPattern = "^(a|an|the|at|by|for|in|of|on|to|up|and|as|but|or|nor)$"
        
        // MARK - go through the words and make them lowercase, if they match and
        //        are not the first word; capitalized otherwise.
        for (index, word) in words.enumerated() {
            
            if index > 0 && word.isMatchedBy(prepositionPattern, regexOptions: [ .caseInsensitive ]) {
                
                newString += word.lowercased()
                
            } else {
                
                newString += word.lowercased().firstLetterUppercased()
                
            }
            
        }
        
        return newString
        
    }

}

let goo: [String] = []
goo.prefix(1)

let myStr = "a farewell to arms ".titleCasedAsEnglishUS()

var splitter = myStr.split
var gen = splitter.makeIterator()
gen.next()

splitter.first
(splitter.dropFirst()).first
splitter.first
