//
//  RegexHelper.swift
//  RegexHelper
//
//  Created by Louis Melahn on 5/5/16.
//  Copyright © 2016 Louis Melahn.
//
//  This file is licensed under the MIT license.
//

import Foundation

public extension String {
    
    public func getCharacterFromIntIndex (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        
        assert(i >= 0, "Index is too small")
        assert(i <= self.characters.count, "Index is too large")
        
        return String(getCharacterFromIntIndex(i) as Character)
    }
    
    public subscript (range: Range<Int>) -> String {
        
        return self[swiftRange(range)]
        
    }
}

// MARK - Adds a property returning the range representing the whole string.
public extension String {
    
    /// Returns the range of the whole string.
    var wholeString: Range<String.Index> {
        
        return Range(self.startIndex ..< self.endIndex)
        
    }
    
    /// Returns the range of the whole string, as an NSRange
    var wholeStringNsRange: NSRange {
        
        return NSMakeRange(0, self.utf16.count)
        
    }
    
}

// MARK - Adds methods to convert between Swift String ranges and `NSRange`s and ranges of integers
public extension String {
    
    /// Returns a Swift-String-compatible range based on a range of integers
    public func swiftRange (intRange: Range<Int>) -> Range<String.Index> {
        
        assert (intRange.startIndex >= 0, "Start index is too small (less than 0)")
        
        var inputStartIndex = intRange.startIndex
        var inputEndIndex = intRange.endIndex
        let totalCharacters = self.characters.count
        
        // If the start index is greater than the number of characters,
        // reduce the start index to the number characters, so as to
        // return an empty string.
        if inputStartIndex > totalCharacters {
            inputStartIndex = totalCharacters
        }
        
        // If the range rolls off the end of the string,
        // just return whatever much of the string you can.
        if inputEndIndex > totalCharacters {
            inputEndIndex = totalCharacters
        }
        
        let outputStartIndex = startIndex.advancedBy(inputStartIndex)
        let outputEndIndex = outputStartIndex.advancedBy(inputEndIndex - inputStartIndex)
        
        return Range(outputStartIndex ..< outputEndIndex)
        
    }
    
    /// Returns a Swift-String-compatible range, based on an NSRange
    public func swiftRange (nsRange: NSRange) -> Range<String.Index>? {
        
        let fromUTF16 = self.utf16.startIndex.advancedBy(nsRange.location, limit: self.utf16.endIndex)
        let toUTF16 = fromUTF16.advancedBy(nsRange.length, limit: self.utf16.endIndex)
        
        if let from = String.Index(fromUTF16, within: self),
            let to = String.Index(toUTF16, within: self) {
            
            return from ..< to
            
        }
        
        return nil
    }
    
    /// Returns an NSRange, based on a Swift-String-compatible range
    public func nsRange(swiftRange: Range<String.Index>) -> NSRange {
        
        let utf16view = self.utf16
        let from = String.UTF16View.Index(swiftRange.startIndex, within: utf16view)
        let to = String.UTF16View.Index(swiftRange.endIndex, within: utf16view)
        
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
        
    }

    /// Returns and NSRange, based on a range of integers
    public func nsRange(intRange: Range<Int>) -> NSRange {
        
        let swiftRange = self.swiftRange(intRange)
        return nsRange(swiftRange)
        
    }
    
    
}

// MARK - adds the `matches` method to String, which takes (at a minimum)
//        a pattern to match, and returns an Match object with all the matches
public extension String {
    
    private func nsMatches (regex: NSRegularExpression) -> [NSTextCheckingResult] {
        return self.nsMatches(regex, options: [])
    }
    
    private func nsMatches (regex: NSRegularExpression, options: NSMatchingOptions) -> [NSTextCheckingResult] {
        // NOTE that NSMakeRange counts using utf16 code points, not the total number of characters.
        // Hence, I must give it self.utf16.count, NOT self.characters.count.
        return regex.matchesInString(self, options: options, range: NSMakeRange(0, self.utf16.count))
    }
    
    private func validateRegex(pattern: String) -> Bool {
        
        do {
            
            let _ = try NSRegularExpression(pattern: pattern, options: [])
            return true
            
        } catch {
            
            return false
            
        }
        
    }
    
    /// Returns an Matches object based on a regex pattern.
    /// Uses default regex and matching options.
    public func matches(pattern: String) -> Matches {
        
        return matches(pattern, regexOptions: [], matchingOptions: [])
        
    }
    
    /// Returns an Matches object based on a regex pattern.
    /// Uses matching options, the the regex options need to be specified.
    /// Equivalent to `String.matches(`_pattern_`, regexOptions: `_options_`, [])`.
    public func matches(pattern: String, regexOptions: NSRegularExpressionOptions) -> Matches {
        
        return matches(pattern, regexOptions: regexOptions, matchingOptions: [])
        
    }
    
    /// Returns an Matches object based on a regex pattern
    /// and an array of NSMatchingOptions.
    public func matches(pattern: String,
                   regexOptions: NSRegularExpressionOptions,
                   matchingOptions: NSMatchingOptions) -> Matches {
        
        assert(validateRegex(pattern), "An invalid regex pattern was given: `\(pattern)`")
        
        let regex = try! NSRegularExpression(pattern: pattern, options: regexOptions)
        return matches(regex, options: matchingOptions)
    }

    
    /// Returns an Matches object based on a regex pattern.
    /// Uses the default options.
    public func matches(regex: NSRegularExpression) -> Matches {
        return matches(regex, options: [])
    }
    
    public func matches(regex: NSRegularExpression, options: NSMatchingOptions) -> Matches {
        
        let nsMatches = self.nsMatches(regex, options: options)
        return Matches(matches: nsMatches, input: self)
        
    }
}

// MARK - Adds an `isMatchedBy` function to String for convenience.
public extension String {

    /// Returns `true` if `regex` matches the string (`self`).
    /// This is the base implementation for all the rest.
    public func isMatchedBy(regex: NSRegularExpression, matchingOptions: NSMatchingOptions) -> Bool {
        
        let matches = self.matches(regex, options: matchingOptions)
        
        if let _ = matches.first {
            
            return true
        
        } else {
            
            return false
            
        }
    
    }
    
    /// Returns `true` if `regex` matches the string (`self`).
    /// Uses a regex with the default matching options.
    public func isMatchedBy(regex: NSRegularExpression) -> Bool {
        
        return isMatchedBy(regex, matchingOptions: [])
        
    }
    
    /// Returns `true` if `regex` matches the string (`self`).
    /// Uses a string and allows configuring the regex and matching options
    public func isMatchedBy(pattern: String,
                   regexOptions: NSRegularExpressionOptions,
                   matchingOptions: NSMatchingOptions) -> Bool {
        
        assert(validateRegex(pattern), "Invalid regex pattern given: \(pattern)")
        
        let regex = try! NSRegularExpression(pattern: pattern, options: regexOptions)
        
        return isMatchedBy(regex, matchingOptions: matchingOptions)
        
    }
    
    /// Returns `true` if `regex` matches the string (`self`).
    /// Uses a string and allows configuring the regex options,
    /// but uses the default matching options
    public func isMatchedBy(pattern: String, regexOptions: NSRegularExpressionOptions) -> Bool {
        
        return isMatchedBy(pattern, regexOptions: regexOptions, matchingOptions: [])
        
    }
    
    /// Returns `true` if `regex` matches the string (`self`).
    /// Uses a string with the default regex and matching options
    public func isMatchedBy(pattern: String) -> Bool {
        
        return isMatchedBy(pattern, regexOptions: [], matchingOptions: [])
        
    }

}

// MARK - Adds a replaceAll function to String
public extension String {
    
    /// Does a replaceAll with the possibility of setting matching options.
    public func replaceAll (regex: NSRegularExpression,
                            withTemplate: String,
                            usingMatchingOptions: NSMatchingOptions) -> String {
        
        return regex.stringByReplacingMatchesInString(self, options: usingMatchingOptions, range: self.wholeStringNsRange, withTemplate: withTemplate)
        
    }
    
    /// Does a replaceAll using the default matching options.
    public func replaceAll(regex: NSRegularExpression, withTemplate: String) -> String {
        
        return replaceAll(regex, withTemplate: withTemplate, usingMatchingOptions: [])
        
    }
    
    /// Does a replaceAll using a string pattern, with the
    /// possibility of setting regex and matching options.
    public func replaceAll(pattern: String,
                           withTemplate: String,
                           usingRegexOptions: NSRegularExpressionOptions,
                           usingMatchingOptions: NSMatchingOptions) -> String {
        
        let regex = try! NSRegularExpression(pattern: pattern, options: usingRegexOptions)
        
        return replaceAll(regex, withTemplate: withTemplate, usingMatchingOptions: usingMatchingOptions)
        
    }
    
    /// Does a replaceAll using a string pattern, with
    /// the possibility of setting the regex options, but
    /// using the default matching options
    public func replaceAll(pattern: String,
                           withTemplate: String,
                           usingRegexOptions: NSRegularExpressionOptions) -> String {
        
        return replaceAll(pattern, withTemplate: withTemplate, usingRegexOptions: usingRegexOptions, usingMatchingOptions: [])
        
    }

    /// Does a replaceAll using a string pattern, using all the default options.
    public func replaceAll(pattern: String, withTemplate: String) -> String {
        
        return replaceAll(pattern, withTemplate: withTemplate, usingRegexOptions: [])

    }
    
}

public struct Matches {
    
    private var nsMatches: [NSTextCheckingResult]
    private var input: String
    
    init(matches: [NSTextCheckingResult], input: String) {
        self.nsMatches = matches
        self.input = input
    }
}

// MARK - makes the matches type accessible by index
extension Matches : CollectionType {
    
    public typealias Index = Int
    
    public var startIndex : Int { return 0 }
    
    public var endIndex : Int { return nsMatches.count }
    
    public subscript (i: Int) -> Match {
        
        return Match(match: nsMatches[i], input: input)
        
    }
    
}

// MARK - makes matches iterable
extension Matches : SequenceType {
    
    public struct Generator : GeneratorType {
        
        public typealias Element = Match
        
        private var matches : [NSTextCheckingResult]
        private var input: String
        private var index = 0
        
        init (matches: [NSTextCheckingResult], input: String) {
            self.matches = matches
            self.input = input
        }
        
        mutating public func next() -> Match? {
            let oldIndex = index
            index += 1
            
            if (oldIndex < matches.count) {
                return Match(match: matches[oldIndex], input: input)
            } else {
                return nil
            }
        }
        
    }
    
    public func generate() -> Generator {
        return Generator(matches: nsMatches, input: input)
    }
}

public struct Match {
    
    public var pre: String {
        
        let range = input.swiftRange(nsMatch_.range)
        assert(range != nil, "A match was given, but the range it returned was nil")
        
        return input[input.startIndex..<range!.startIndex]
        
    }
    
    public var post: String {
        
        let range = input.swiftRange(nsMatch_.range)
        assert(range != nil, "A match was given, but the range it returned was nil")
        
        return input[range!.endIndex..<input.endIndex]
        
    }
    
    public var hit: String {
        
        let range = input.swiftRange(nsMatch_.range)
        assert(range != nil, "A match was given, but the range it returned was nil")
        
        return input[range!]
    }
    
    private var input: String
    private var nsMatch_: NSTextCheckingResult
    
    init (match: NSTextCheckingResult, input: String) {
        self.nsMatch_ = match
        self.input = input
    }
    
}

// MARK - makes the match type accessible by index
extension Match : CollectionType {
    
    public typealias Index = Int
    
    public var startIndex : Int { return 0 }
    
    public var endIndex : Int { return nsMatch_.numberOfRanges }
    
    public subscript (i: Int) -> String {
        
        let range = input.swiftRange(nsMatch_.rangeAtIndex(i))
        assert(range != nil, "An invalid index was given")
        
        return input[range!]

    }
    
}

extension Match : SequenceType {
    
    public struct Generator : GeneratorType {
        
        public typealias Element = String
        
        private var index = 0   // Note that one submatch is guaranteed.
        private var match: Match
        private let endIndex: Int
        
        init (match: Match, endIndex: Int) {
            self.match = match
            self.endIndex = endIndex
        }
        
        mutating public func next() -> Element? {
            if index==endIndex {
                return nil
            } else {
                let oldIndex = index
                index += 1
                return match[oldIndex]
            }
        }
    }
    
    public func generate() -> Generator {
        return Generator(match: self, endIndex: count)
    }
    
}

// MARK - make it possible to use a Match as a variable by the print function
extension Match: CustomStringConvertible {
    
    public var description: String {
        
        return self.hit
        
    }
    
}

// MARK - returns a Range<String.Index> where the hit is.
extension Match {
    
    public var range: Range<String.Index> {
        
        return input.swiftRange(nsMatch_.range)!
        
    }
    
}

// MARK - an extension to String that provides a regex-based splitter.
extension String {
    
    public struct Splitter: SequenceType {
        
        let input: String
        let separator: String
        
        public init(input: String, usingSeparator separator: String) {
            
            self.input = input
            self.separator = separator
            
        }
        
        public struct Generator : GeneratorType {
            
            public typealias Element = String
            
            let separator: String
            var input: String?
            
            init(input: String, separator: String) {
                
                self.input = input
                self.separator = separator
                
            }
            
            mutating public func next() -> Element? {
                
                if let (first, rest) = input?.splitFirst(usingSeparator: separator) {
                    
                    if let first = first {
                        
                        input = rest
                        return first
                        
                    } else {
                        
                        input = nil
                        return rest
                        
                    }
                    
                } else {
                    
                    return nil
                    
                }
            }
        }
        
        public func generate() -> Generator {
            
            return Generator(input: input, separator: separator)
            
        }
        
    }
    
    /// This function will attempt to break a string in two
    /// at the first opportunity, eliminating the string that
    /// matches `sepearatorRegex`. Returns a tuple with the 
    /// front part that has been "broken off" and the remaininder
    /// of the string. For instance,
    /// `"aaaa##aaaaa#aaa".splitFirst("#+")` will return `("aaaa", "aaaaa#aaa")`
    /// If one of the two pieces turns out to be empty, `splitFirst` will return
    /// `nil`. For example, if the separator pattern matches nothing, the method
    /// will return `(nil,` original-string`)`. If the match is at very end, the
    /// method will return `(`front-part-of-string`, nil)`. If the original string
    /// is empty, the method will return `(nil, nil)`.
    public func splitFirst(usingSeparator separator: String) -> (String?, String?) {
        
        if let match = self.matches(separator,
                                    regexOptions: [ .DotMatchesLineSeparators ]).first {
            
            let pre = match.pre
            let post = match.post
            
            return (pre=="" ? nil : pre, post=="" ? nil : post)
            
        } else {
            
            return (nil, self=="" ? nil : self)
            
        }
    }
    
    /// Returns a `String.Splitter` object that represents the pieces
    /// of a string that has been split according to a separator defined
    /// by a regex pattern. The `String.Splitter` can be used in a `for`
    /// loop or converted into an array by using the appropriate cast
    /// (e.g., `Array(mySplitter)`).
    public func split(usingSeprator separator: String) -> String.Splitter {
        
        return String.Splitter(input: self, usingSeparator: separator)
        
    }
    
    /// Returns a `String.Splitter` object that represents the pieces
    /// of a string that has been split according to white space (including
    /// newlines and tabs). The `String.Splitter` can be used in a `for` loop
    /// or converted into an array by using the appropriate cast 
    /// (e.g., `Array(mySplitter)`).
    public var split: String.Splitter {
        
        return self.split(usingSeprator: "\\s+")
        
    }
    
}

extension String.Splitter: CollectionType {
    
    public typealias Index = Int
    
    public var startIndex : Int { return 0 }
    
    public var endIndex : Int { var count = 0; for _ in self { count += 1 }; return count }
    
    public subscript (i: Int) -> String {
        
        var count = 0
        
        
        for string in self {
            
            if count==i {
                return string
            }
            
            count += 1
        }
        
        return ""
    }
}