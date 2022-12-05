//
//  main.swift
//  AdventOfCode2022_Day5
//
//  Created by Hämälistö Heikki on 5.12.2022.
//

import Foundation

typealias Crate = Character

func readData(fromFile file: String, withExtension fileExtension: String = "txt") -> (stacks: [Stack], moves:[Move]) {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    guard let filePath = bundle?.path(forResource: file, ofType: fileExtension) else {
        print("\(file).\(fileExtension) not found")
        return ([],[])
    }
    
    do {
        var stacks = Array<Stack>()
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        
        var isReadingMoves = false
        var crateLines: ArraySlice<String> = []
        var moveLines: ArraySlice<String> = []
        var stackIds: [Int] = []
        for (index, line) in lines.enumerated() {
            let cleaned = line.filter { $0 != " " }
            
            if cleaned.allSatisfy({ char in
                char.isNumber
            }) {
                // Stack id row
                stackIds = line.components(separatedBy: " ").compactMap { Int($0) }
                crateLines = lines.prefix(upTo: index)
                if lines.count > index {
                    moveLines = lines.suffix(from: index + 1).filter { $0.isEmpty == false }
                }
                break
            }
        }
        
        // Create stacks
                
        for stackId in stackIds {
            let stack = Stack(id: stackId)
            stacks.append(stack)
        }
        
        // Add crates to the stacks
        
        for var line in crateLines {
            var crates: [String] = []
            line = line.replacingOccurrences(of: "    ", with: " ")
            crates = line.components(separatedBy: " ")
            for (stackIndex, crate) in crates.enumerated() {
                guard crate.isEmpty == false else { continue }
                guard stackIndex < stacks.count else { continue }
                let crateOpened = Crate(crate.filter { $0.isLetter })
                stacks[stackIndex].addToBottom(crate: crateOpened)
            }
        }
        
        // Create moves
        
        var moves: [Move] = []
        for moveLine in moveLines {
            let splitted = moveLine.split(separator: " ")
            let numbers = splitted.compactMap { Int($0) }
            guard ["move", "from", "to"].allSatisfy({ splitted.contains($0) }) else { continue }
            guard splitted.count == 6 else { continue }
            guard numbers.count == 3 else { continue }
            let move = Move(count: numbers[0], from: numbers[1], to: numbers[2])
            moves.append(move)
        }
        
        return (stacks: stacks, moves: moves)
        
    } catch {
        print("Contents could not be loaded")
    }
        
    return ([],[])
}


// MARK: - Part 1

func part1() {
    var (stacks, moves) = readData(fromFile: "input")

    for move in moves {
        for _ in 0..<move.count {
            if let crate = stacks[move.from - 1].takeTop() {
                stacks[move.to - 1].push(crate: crate)
            }
        }
    }

    let answer = stacks.reduce("") { partialResult, stack in
        if let crate = stack.peekTop() {
            return partialResult.appending(String(crate))
        }
        return partialResult
    }
    
    print(answer)
}


// MARK: - Part 2

func part2() {
    var (stacks, moves) = readData(fromFile: "input")

    for move in moves {
        let crates = stacks[move.from - 1].takeTop(k: move.count)
        if crates.isEmpty == false {
            stacks[move.to - 1].push(crateStack: crates)
        }
    }

    let answer = stacks.reduce("") { partialResult, stack in
        if let crate = stack.peekTop() {
            return partialResult.appending(String(crate))
        }
        return partialResult
    }
    
    print(answer)
}


part1()
part2()
