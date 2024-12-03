//
//  main.swift
//  AdventOfCode2024_Day2
//
//  Created by Hämälistö Heikki on 2.12.2024.
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

func isSafeReport(_ report: [Int]) -> Bool {
    return isMonotonic(report) && isDifferenceWithinRange(report)
}

func isMonotonic(_ report: [Int]) -> Bool {
    let increasing = zip(report, report.dropFirst()).allSatisfy { $0 <= $1 }
    let decreasing = zip(report, report.dropFirst()).allSatisfy { $0 >= $1 }
    return increasing || decreasing
}

func isDifferenceWithinRange(_ levels: [Int]) -> Bool {
    // Check if differences between adjacent elements are in [1, 3]
    return zip(levels, levels.dropFirst()).allSatisfy { abs($0 - $1) >= 1 && abs($0 - $1) <= 3 }
}

func isSafeReportWithSingleBadLevelAllowed(_ report: [Int]) -> Bool {
    if isMonotonic(report) && isDifferenceWithinRange(report) {
        return true
    }
    
    // Check safety by removing one element at a time
    for i in 0..<report.count {
        var modifiedReport = report
        modifiedReport.remove(at: i)
        if isSafeReport(modifiedReport) {
            return true
        }
    }
    
    return false
}

func countSafeReports(_ reports: [[Int]]) -> Int {
    return reports.reduce(into: 0) { partialResult, report in
        partialResult += isSafeReport(report) ? 1 : 0
    }
}

func countSafeReportsSingleBadLevelAllowed(_ reports: [[Int]]) -> Int {
    return reports.reduce(into: 0) { partialResult, report in
        partialResult += isSafeReportWithSingleBadLevelAllowed(report) ? 1 : 0
    }
}

let lines = readLines(fromFile: "input")
let reports = lines.map { $0.split { $0.isWhitespace }.compactMap { Int($0) }}


// MARK: - Part 1
let safeReports = countSafeReports(reports)
print("Part 1: Safe reports", safeReports)

// MARK: - Part 2
let safeReportsWithSingleBadLevelAllowed = countSafeReportsSingleBadLevelAllowed(reports)
print("Part 2: Safe reports with single bad level allowed", safeReportsWithSingleBadLevelAllowed)
