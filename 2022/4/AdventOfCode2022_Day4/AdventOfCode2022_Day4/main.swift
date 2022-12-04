//
//  main.swift
//  AdventOfCode2022_Day4
//
//  Created by Hämälistö Heikki on 4.12.2022.
//

import Foundation

func readData(fromFile file: String, withExtension fileExtension: String = "txt") -> [(first: Set<Int>, second: Set<Int>)] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    guard let filePath = bundle?.path(forResource: file, ofType: fileExtension) else {
        print("\(file).\(fileExtension) not found")
        return []
    }
    
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { $0.isEmpty == false }
        let sectionSetPairs = lines
            .map { $0.split(separator: ",", omittingEmptySubsequences: true) }
            .compactMap { pair -> (first: Set<Int>, second: Set<Int>)? in
                guard pair.count == 2 else { return nil }
                let firstElfSections = pair[0].split(separator: "-").compactMap { Int($0) }
                let secondElfSections = pair[1].split(separator: "-").compactMap { Int($0) }
                let firstRange = firstElfSections[0]...firstElfSections[1]
                let secondRange = secondElfSections[0]...secondElfSections[1]
                let firstSet = Set(firstRange)
                let secondSet = Set(secondRange)
                return (first: firstSet, second: secondSet)
            }
            
        return sectionSetPairs
        
    } catch {
        print("Contents could not be loaded")
    }
        
    return []
}



let sections = readData(fromFile: "input", withExtension: "txt")

// MARK: - Part 1

let fullyContainedSectionsCount = sections.reduce(0) { partialResult, pair in
    if pair.first.isSubset(of: pair.second) || pair.second.isSubset(of: pair.first) {
        return partialResult + 1
    }
    return partialResult
}

print(fullyContainedSectionsCount)


// MARK: - Part 2

let overlappingSectionsCount = sections.reduce(0) { partialResult, pair in
    if pair.first.isDisjoint(with: pair.second) {
        return partialResult
    }
    return partialResult + 1
}

print(overlappingSectionsCount)
