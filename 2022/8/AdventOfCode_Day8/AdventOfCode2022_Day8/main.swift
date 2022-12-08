//
//  main.swift
//  AdventOfCode_Day8
//
//  Created by Hämälistö Heikki on 8.12.2022.
//

import Foundation

func readData(fromFile file: String, withExtension fileExtension: String = "txt") -> [[Character]] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    guard let filePath = bundle?.path(forResource: file, ofType: fileExtension) else {
        print("\(file).\(fileExtension) not found")
        return []
    }
    
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let treeHeights = content.components(separatedBy: .newlines)
            .filter { $0.isEmpty == false }
            .map { Array($0) }
        
        return treeHeights
    } catch {
        print("Contents could not be loaded")
    }
        
    return []
}


let trees = readData(fromFile: "input")

// MARK: - Part 1

func part1() {
    var visibleTreeCount = 0
    for (rowIndex, row) in trees.enumerated() {
        for (columnIndex, tree) in row.enumerated() {
            let isEdge = rowIndex == 0 || rowIndex == trees.count-1 || columnIndex == 0 || columnIndex == row.count - 1
            if isEdge {
                visibleTreeCount += 1
                continue
            }

            let isVisibleFromLeft = row[0..<columnIndex].allSatisfy { $0 < tree }
            guard isVisibleFromLeft == false else {
                visibleTreeCount += 1
                continue
            }
            
            let isVisibleFromRight = row[columnIndex+1..<row.count].allSatisfy { $0 < tree }
            guard isVisibleFromRight == false else {
                visibleTreeCount += 1
                continue
            }
            
            let column = trees.map { $0[columnIndex] }
            let isVisibleFromTop = column[0..<rowIndex].allSatisfy { $0 < tree }
            guard isVisibleFromTop == false else {
                visibleTreeCount += 1
                continue
            }
            
            let isVisibleFromBottom = column[rowIndex+1..<trees.count].allSatisfy { $0 < tree }
            guard isVisibleFromBottom == false else {
                visibleTreeCount += 1
                continue
            }
        }
    }
    print(visibleTreeCount)
}

// MARK: - Part 2

func part2() {
    var highestScenicScore = 0
    let rowCount = trees.count
    let columnCount = trees.first?.count ?? 0
    
    for (rowIndex, row) in trees.enumerated() {
        guard rowIndex > 0 || rowIndex < rowCount - 1 else {
            continue
        }
        
        for (columnIndex, tree) in row.enumerated() {
            guard columnIndex > 0 || columnIndex < columnCount - 1 else {
                continue
            }
                      
            let column = trees.map { $0[columnIndex] }

            // Left
            let lastIndexBlockingTreeLeft = row[0..<columnIndex].lastIndex(where: { $0 >= tree }) as Int?
            let visibleTreesLeft = columnIndex - (lastIndexBlockingTreeLeft ?? 0)
            
            // Right
            let firstIndexBlockingTreeRight = row[columnIndex+1..<columnCount].firstIndex(where: { $0 >= tree }) as Int?
            let visibleTreesRight = (firstIndexBlockingTreeRight ?? columnCount) - columnIndex - 1

            // Up
            let lastIndexBlockingTreeUp = column[0..<rowIndex].lastIndex(where: { $0 >= tree }) as Int?
            let visibleTreesUp = rowIndex - (lastIndexBlockingTreeUp ?? 0)
            
            // Down
            let firstIndexBlockingTreeDown = column[rowIndex+1..<rowCount].firstIndex(where: { $0 >= tree }) as Int?
            let visibleTreesDown = (firstIndexBlockingTreeDown ?? rowCount - 1) - rowIndex
            
            let scenicScore = visibleTreesLeft * visibleTreesRight * visibleTreesUp * visibleTreesDown
            
            highestScenicScore = max(highestScenicScore, scenicScore)
        }
    }
    print(highestScenicScore)
}

part1()
part2()
