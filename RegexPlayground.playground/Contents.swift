//: Playground - noun: a place where people can play

import Cocoa
import RegexHelper

var str = "We hold these éh☺️ Truths to be self-evident"

extension String {
    
    var titleCaseEnglishUS: String {
        
        let pattern = "\\b(a|an|the|at|by|for|in|of|on|to|up|and|as|but|or|nor)\\b"
        
        var workingString = self.capitalizedString
        
        for match in self.capitalizedString.matches(pattern, regexOptions: [.CaseInsensitive]) {
                                                        
            workingString = workingString.replaceAll("\\b\(match.hit)\\b",
                                                             withTemplate: match.hit.lowercaseString)
            
        }
        
        return workingString
        
    }
    
}




"a farewell to arms"
