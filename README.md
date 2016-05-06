# RegexHelper
A Swifter framwork to simplify using regular expressions

# Installation
The simplest way to install this project is simply to copy the file `RegexHelper.swift` and include it in your project.

Alternatively, copy the entire project and add it to an existing project. (It is sufficient to drag and drop the project into the existing one, or to use the menu item ‘Add Files to “_Project Name_”…’) In that case, it is necessary to add in each source file the following import statement:

```swift
import RegexHelper
```

The import statement is not necessary if you simply incorporate `RegexHelper.swift` into your project.

# Usage

The library essentially adds three methods to the String class: `matches`, `isMatchedBy`, and `replaceAll`.

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
