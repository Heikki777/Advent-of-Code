//
//  main.swift
//  AdventOfCode2022_Day3
//
//  Created by Hämälistö Heikki on 3.12.2022.
//

import Foundation

func readData(fromFile file: String) -> [String] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            return lines.filter { !$0.isEmpty }
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}

/// Converts a Character to Int.
/// Lowercase item types **a** through **z** have priorities 1 through 26.
/// Uppercase item types **A** through **Z** have priorities 27 through 52.
func getValue(for character: Character) -> Int {
    guard let asciiValue = character.asciiValue else { return 0 }
    var value = Int(asciiValue)
    
    if character.isLowercase {
        value = value - 96
    } else if character.isUppercase {
        value = value - 38
    }
    return value
}

let rucksacks = readData(fromFile: "input")

// MARK: - Part 1

let commonItemsSum = rucksacks.reduce(0) { partialResult, rucksack in
    let pivotIndex = rucksack.index(rucksack.startIndex, offsetBy: rucksack.count / 2)
    let firstHalf = rucksack.prefix(upTo: pivotIndex)
    let secondHalf = rucksack.suffix(from: pivotIndex)
    let commonItems = Set(firstHalf).intersection(Set(secondHalf))
    return partialResult + commonItems.reduce(0) { $0 + getValue(for: $1) }
}
print(commonItemsSum)


// MARK: - Part 2

let rucksackGroups = rucksacks.chunked(into: 3)
var repeatedItemsInGroups: [Character] = []

rucksackGroups.forEach { group in
    var repeatedItemsInGroup: Set<Character> = Set()
    group.forEach { rucksack in
        if repeatedItemsInGroup.isEmpty {
            repeatedItemsInGroup.formUnion(Set(rucksack))
        } else {
            repeatedItemsInGroup.formIntersection(Set(rucksack))
        }
    }
    repeatedItemsInGroups.append(contentsOf: repeatedItemsInGroup)
}

let sumOfRepeatedItemsInGroups = repeatedItemsInGroups.reduce(0, { partialResult, char in
    return partialResult + getValue(for: char)
})

print(sumOfRepeatedItemsInGroups)
