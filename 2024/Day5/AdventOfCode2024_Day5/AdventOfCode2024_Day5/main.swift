//
//  main.swift
//  AdventOfCode2024_Day5
//
//  Created by Hämälistö Heikki on 5.12.2024.
//

import Foundation

func readLines(fromFile file: String) -> [String] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            var lines = content.components(separatedBy: .newlines)
            
            // Remove any trailing empty line
            if let lastLine = lines.last, lastLine.isEmpty {
                lines.removeLast()
            }
            
            return lines
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}

let lines = readLines(fromFile: "input")
if let emptyLineIndex = lines.firstIndex(of: "") {
    let splittedRules = lines[0 ..< emptyLineIndex].map { $0.split(separator: "|") }
    let rules: [String: (Int, Int)] = splittedRules
        .filter({ $0.count == 2 })
        .reduce(into: [String: (Int, Int)]()) { result, components in
            if let first = Int(components[0]), let second = Int(components[1]) {
                result["\(first),\(second)"] = (first, second)
            }
        }
    
    var updates = lines[emptyLineIndex.advanced(by: 1) ..< lines.endIndex].map { $0.split(separator: ",").compactMap { Int($0) }}
    var isChangesMade = false
    var updateRound = 1
    var updateNeedsFixCheck: [Bool] = Array.init(repeating: true, count: updates.count)
    var middlePageNumbersInCorrectUpdates: [Int] = []
    var middlePageNumbersInCorrectedUpdates: [Int: Int] = [:]
    
    repeat {
        isChangesMade = false
        for var (j, update) in updates.enumerated() {
            // Check if the update needs to be fix checked to avoid unneccessary check-ups.
            if updateNeedsFixCheck[j] {
                let (modifiedUpdate, swapped) = fixUpdateIfNeeded(update: &update, rules: rules)
                if swapped {
                    isChangesMade = true
                    updates[j] = modifiedUpdate
                    middlePageNumbersInCorrectedUpdates[j] = modifiedUpdate[modifiedUpdate.count / 2]
                    updateNeedsFixCheck[j] = true
                } else {
                    updateNeedsFixCheck[j] = false
                    if updateRound == 1 {
                        middlePageNumbersInCorrectUpdates.append(update[update.count / 2])
                    }
                }
            }
        }
        updateRound += 1
    } while isChangesMade
    
    print("Part 1:", middlePageNumbersInCorrectUpdates.reduce(into: 0) { $0 = $0 + $1 })
    print("Part 2:", middlePageNumbersInCorrectedUpdates.values.reduce(into: 0) { $0 = $0 + $1 })
}

func fixUpdateIfNeeded(update: inout [Int], rules: [String: (Int, Int)]) -> (update: [Int], swapped: Bool) {
    let pairs = zip(update, update.dropFirst())
    var swapped = false
    for (i, pair) in pairs.enumerated() {
        // Rule not followed -> Swap the numbers
        if rules["\(pair.1),\(pair.0)"] != nil {
            update.swapAt(i, i+1)
            swapped = true
        }
    }
    return (update, swapped)
}


