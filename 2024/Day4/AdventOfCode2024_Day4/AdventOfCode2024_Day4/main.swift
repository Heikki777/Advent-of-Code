//
//  main.swift
//  AdventOfCode2024_Day4
//
//  Created by Hämälistö Heikki on 4.12.2024.
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

func transpose<T>(_ matrix: [[T]]) -> [[T]] {
    guard let firstRow = matrix.first else { return [] }
    return (0..<firstRow.count).map { columnIndex in
        matrix.map { $0[columnIndex] }
    }
}

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

func getAllDiagonals<T>(from matrix: [[T]]) -> ([ [T] ], [ [T] ], [ [T] ], [ [T] ]) {
    let rowCount = matrix.count
    let colCount = matrix.first?.count ?? 0

    var topLeftToBottomRight: [[T]] = []
    var topRightToBottomLeft: [[T]] = []
    var bottomLeftToTopRight: [[T]] = []
    var bottomRightToTopLeft: [[T]] = []

    var visited: Set<Coordinate> = []

    // Helper function to add a diagonal and mark coordinates as visited
    func addDiagonal(row: Int, col: Int, rowStep: Int, colStep: Int, storage: inout [[T]]) {
        var diagonal: [T] = []
        var r = row
        var c = col
        while r >= 0 && r < rowCount && c >= 0 && c < colCount {
            if !visited.contains(Coordinate(row: r, col: c)) {
                diagonal.append(matrix[r][c])
                visited.insert(Coordinate(row: r, col: c)) // Mark as visited
            }
            r += rowStep
            c += colStep
        }
        if !diagonal.isEmpty {
            storage.append(diagonal)
        }
    }

    // Top-left to bottom-right
    for col in 0..<colCount {
        addDiagonal(row: 0, col: col, rowStep: 1, colStep: 1, storage: &topLeftToBottomRight)
    }
    for row in 1..<rowCount {
        addDiagonal(row: row, col: 0, rowStep: 1, colStep: 1, storage: &topLeftToBottomRight)
    }

    visited.removeAll()

    // Top-right to bottom-left
    for col in (0..<colCount).reversed() {
        addDiagonal(row: 0, col: col, rowStep: 1, colStep: -1, storage: &topRightToBottomLeft)
    }
    for row in 1..<rowCount {
        addDiagonal(row: row, col: colCount - 1, rowStep: 1, colStep: -1, storage: &topRightToBottomLeft)
    }

    visited.removeAll()

    // Bottom-left to top-right
    for row in (0..<rowCount).reversed() {
        addDiagonal(row: row, col: 0, rowStep: -1, colStep: 1, storage: &bottomLeftToTopRight)
    }
    for col in 1..<colCount {
        addDiagonal(row: rowCount - 1, col: col, rowStep: -1, colStep: 1, storage: &bottomLeftToTopRight)
    }

    visited.removeAll()

    // Bottom-right to top-left
    for row in (0..<rowCount).reversed() {
        addDiagonal(row: row, col: colCount - 1, rowStep: -1, colStep: -1, storage: &bottomRightToTopLeft)
    }
    for col in (0..<(colCount - 1)).reversed() {
        addDiagonal(row: rowCount - 1, col: col, rowStep: -1, colStep: -1, storage: &bottomRightToTopLeft)
    }

    return (topLeftToBottomRight, topRightToBottomLeft, bottomLeftToTopRight, bottomRightToTopLeft)
}

let lines = readLines(fromFile: "input")
let table = lines.map { Array($0) }

// MARK: - Part 1

let transposed = transpose(lines.map { Array($0) }).map { String($0) }
var occurrences: [Regex<Regex<Substring>.RegexOutput>.Match] = []

// Matches in rows
for line in lines {
    occurrences.append(contentsOf: line.matches(of: /XMAS/)) // forward
    occurrences.append(contentsOf: line.matches(of: /SAMX/)) // reverse
}

// Matches in columns
for line in transposed {
    occurrences.append(contentsOf: line.matches(of: /XMAS/)) // forward
    occurrences.append(contentsOf: line.matches(of: /SAMX/)) // reverse
}

let (tlToBr, trToBl, blToTr, brToTl) = getAllDiagonals(from: lines.map { Array($0) })

for line in tlToBr {
    let matches = String(line).matches(of: /XMAS/)
    occurrences.append(contentsOf: matches)
}

for line in trToBl {
    let matches = String(line).matches(of: /XMAS/)
    occurrences.append(contentsOf: matches)
}

for line in blToTr {
    let matches = String(line).matches(of: /XMAS/)
    occurrences.append(contentsOf: matches)
}

for line in brToTl {
    let matches = String(line).matches(of: /XMAS/)
    occurrences.append(contentsOf: matches)
}

print("Part 1: \(occurrences.count) Occurences")

// MARK: - Part 2

var xmasCount = 0
var xmasCenters: [(Int, Int)] = []

for (i, line) in table.enumerated() {
    for (j, char) in Array(line).enumerated() {
        if i > 0 && i < lines.count - 1 && j > 0 && j < line.count - 1 {
            if char == "A" {
                let diagTlBr = "\(table[i-1][j-1])\(char)\(table[i+1][j+1])"
                let diagTrBl = "\(table[i-1][j+1])\(char)\(table[i+1][j-1])"
                if (diagTlBr == "MAS" || diagTlBr == "SAM") && (diagTrBl == "MAS" || diagTrBl == "SAM") {
                    xmasCount += 1
                }
            }
        }
    }
}

print("Part 2: X-MAS count: \(xmasCount)")
