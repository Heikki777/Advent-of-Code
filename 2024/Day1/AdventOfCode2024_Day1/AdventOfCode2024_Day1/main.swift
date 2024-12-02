//
//  main.swift
//  AdventOfCode2024_Day1
//
//  Created by Hämälistö Heikki on 2.12.2024.
//

import Foundation

// Function to read lines from a text file in the app bundle
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

func processFileData(fromFile file: String) -> (leftList: [Int], rightList: [Int]) {
    let lines = readLines(fromFile: file)
    let (leftList, rightList) = lines.compactMap { line in
        let splitted = line.split { $0.isWhitespace }.compactMap { Int($0) }
        return splitted.count == 2 ? (splitted[0], splitted[1]) : nil
    }
    .reduce(into: (leftList: [Int](), rightList: [Int]())) { result, pair in
        result.leftList.append(pair.0)
        result.rightList.append(pair.1)
    }

    return (leftList: leftList.sorted(), rightList: rightList.sorted())
}

func calculateTotalDistance(betweenLists lists: ([Int], [Int])) -> Int {
    return zip(lists.0, lists.1).reduce(into: 0) { result, pair in
        result += abs(pair.1 - pair.0)
    }
}

func calculateTotalSimilarityScore(betweenLists lists: ([Int], [Int])) -> Int {
    return zip(lists.0, lists.1).reduce(into: 0) { result, pair in
        result += pair.0 * countOccurrences(of: pair.0, in: lists.1)
    }
}

func countOccurrences(of item: Int, in list: [Int]) -> Int {
    return list.reduce(0) { $0 + ($1 == item ? 1 : 0) }
}


let lists = processFileData(fromFile: "input")

// - MARK: Part 1
let diff = calculateTotalDistance(betweenLists: lists)
print("Part 1:", diff)

// - MARK: Part 2
let score = calculateTotalSimilarityScore(betweenLists: lists)
print("Part 2:", score)
