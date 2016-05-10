//: Playground - noun: a place where people can play

import Cocoa
import RegexHelper

var str = "Hello, playground\nWe hold these? Truths to be self-evident."


for word in "We hold these Truths to be self-evident  ".split("\\s+") {
    print(word)
}


let splitter = String.Splitter(input: "We hold these Truths to be self-evident",
                separator: "\\s+")
var gen = splitter.generate()

gen.next()
gen.next()
gen.next()
gen.next()
gen.next()
gen.next()
gen.next()
gen.next()
gen.next()
gen.next()


Array(splitter)

Array(splitter.prefix(4))