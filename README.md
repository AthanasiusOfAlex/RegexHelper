# RegexHelper
A Swift framwork to simplify using regular expressions

# Installation
The simplest way to install this project is simply to copy the file `RegexHelper.swift` and include it in your project.

Alternatively, copy the entire project and add it to an existing project. (It is sufficient to drag and drop the project into the existing one, or to use the menu item ‘Add Files to “_Project Name_”…’) In that case, it is necessary to add in each source file the following import statement:

```swift
import RegexHelper
```

The import statement is not necessary if you simply incorporate `RegexHelper.swift` into your project.

# Usage

The library essentially adds three methods to the String class: `matches`, `isMatchedBy`, and `replaceAll`.

As a bonus, it adds a `split` method and `split` property that break a string into parts, using a regex-based separator. (If all you want to do is split a string at the first opportunity, the `splitFirst` method will do that.)

## String.matches(pattern:)

`matches` simply returns an iterable and indexable list of the matches found a given string. The simplest usage is

```swift
let matches = someStr.matches("regex-pattern")
```

This version uses all the default options; there are also overloads that allow one to use a fully formed NSRegularExpression object, and to take advantage of the various options in NSRegularExpressionOption and NSMatchingOption.

The individual matches can be accessed either by index (warning: you are responsible for making sure that the index is in range), or using a `for` loop.

```swift    
let match = matches[1]
```

It it probably safer to use the following technique:

```swift    
if let match = matches.first {

    // Do whatever you want to do with match.

}
```
    
or else

```swift
for match in matches {

    // Do something with each match.

}
```

Note each match is represented by a Match object. This object, in turn, represents the text that is matched by the pattern as follows:

 - `match.hit` represents the text that matches the entire pattern.
 - `match.pre` represents all the text preceding the matched text.
 - `match.post` represents all the text following the matched text.

For example, if the pattern `([er]+)(l+)([do]+)` is used against the string `Hello, world`, the matches will be `ello` and `rld` (represented by `matches[0]` and `matches[1]`, respectively). Suppose that we let `match = matches[0]` (or `matches.first!`).

In that case, `match.hit` will be, of course, `ello`; `match.pre` will be `H`, and `match.post` will be `, world`.

The submatches may also be cycled through. For instance, consider the following code (which represents the same case as the example):

```swift
let match = "Hello, world".matches("([er]+)(l+)([do]+)").first!

for submatch in match {

    print(submatch)

}
```

It will print

```
ello
e
ll
o
```

As can be seen, the first submatch, `match[0]` or `match.first` is identical to `match.hit`—in other words, it is the entire match. The next submatch, `match[1]`, returns the text matched by the pattern inside the first set of parentheses, `[er]+`, and so on.

If you try to use the Match object in the `print()` function, the contents of `match.hit` will be used.

## String.isMatchedBy(pattern:)

Returns true if the pattern matches the string at least once, and false otherwise. Again, there are overloads for using NSRegularExpression objects and all the corresponding options. For instance,

```swift
"Hello, world".isMatchedBy("He[lo]+")
```

returns `true`. In order to do, say, a case-insensiteive validation, the following code would return `true`:

```swift
"Hello, world".isMatchedBy("hello", regexOptions: [ .CaseInsensitive ])
```

## String.replaceAll(pattern:withTemplate:)

Returns a new string, in which all the matches found within the string are replaced with the given template. Note that NSRegularExpression uses the dollar-sign operator ($) to indicate submatches. (E.g., $1 indicates the first submatch.) For instance,

```swift
"Hello, world".replaceAll("(Hello)(, )(world)", withTemplate: "$3$2$1")
```

will return `world, Hello`. Too make the match case-insensitive, use

```swift
"Hello, world".replaceAll("(hello)(, )(world)",
                          withTemplate: "$3$2$1",
                          usingRegexOptions: [ .CaseInsensitive ])
```

## Splitter

As a bonus, I added a regex-based splitter function. It will take any string and attempt to split it into pieces, using a regular expression to match the text will function as the separator. For example,

```swift
for word in "aaaaaaa##bbbbbb#c######dddd".split(usingSeparator: "#+") {

    print(word)

}
```

will print


```
aaaaaaa
bbbbbb
c
dddd
```

I have also made a property (which does not take arguments) with the same name that splits a string based on whitespace. For example,

```swift
for word in "We hold these Truths to be self-evident".split {

    print(word)

}
```

will print


```
We
hold
these
Truths
to
be
self-evident
```


The `split` method and `split` property both return an object of type `String.Splitter`, which can be used (as in the examples) in a `for` loop. It can easily be converted into an array as follows:

```swift
let words = "We hold these Truths to be self-evident".split
let wordArray = Array(words)
```

or

```swift
let wordArray = Array("We hold these Truths to be self-evident".split)
```

Either example will produce the array `["We", "hold", "these", "Truths", "to", "be", "self-evident"]`.
