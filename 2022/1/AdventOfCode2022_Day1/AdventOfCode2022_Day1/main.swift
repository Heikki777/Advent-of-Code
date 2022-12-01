//
//  main.swift
//  AdventOfCode2022_Day1
//
//  Created by Hämälistö Heikki on 1.12.2022.
//

import Foundation

func readData(fromFile file: String) -> [Elf] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            let elves = lines.split(separator: "")
                .map { $0.compactMap { Int($0) }}
                .map { Elf(foodItemCalories: $0) }
            
            return elves
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}

let elves = readData(fromFile: "input").sorted(by: >)

// MARK: - Part 1
if let top1Elf = elves.first {
    print(top1Elf.totalCalories)
}

// MARK: - Part 2
let top3Elves = elves.prefix(3)
print(top3Elves.map { $0.totalCalories }.reduce(0, +))


