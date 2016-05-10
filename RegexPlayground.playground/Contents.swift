//: Playground - noun: a place where people can play

import Cocoa
import RegexHelper

var str = "Hello, playground\nWe hold these? Truths to be self-evident."

extension Match: CustomStringConvertible {
    
    public var description: String {
        
        return self.hit
        
    }
    
}

extension String {
    
    func split(separator: String) -> [String] {
     
        return []
        
    }
    
}

for match in "Hello, world".matches("([er]+)(l+)([do]+)") {
    print(match)
}

print("=======")
let match = "Hello, world".matches("([er]+)(l+)([do]+)").first!

for submatch in match {
    print(submatch)
}

//extension String {
//    
//    var split: [String]  {
//        
//        return self.splitter("[^\\s]+")
//    
//    }
//    
//    func splitter(separator: String) -> [String] {
//        
//        let matches = self.matches(separator,
//                                   regexOpations: [ .DotMatchesLineSeparators ])
//        
//        var result: [String] = []
//        
//        
//        for match in matches {
//            
//            result.append(match.hit)
//            
//        }
//        
//        return result
//    
//    }
//    
//}

//let words = str.split.sort()
//
//let ints = words.map{ ($0, $0.characters.count) }
//
//for tuple in ints {
//    
//    let (idx, val) = tuple
//    
//    print("\(idx): \(val)")
//    
//}
//
//"asfasdf".splitter("as")
