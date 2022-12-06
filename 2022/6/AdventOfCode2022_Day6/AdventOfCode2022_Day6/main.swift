//
//  main.swift
//  AdventOfCode2022_Day6
//
//  Created by Hämälistö Heikki on 6.12.2022. 🇫🇮
//

import Foundation

func readData(fromFile file: String, withExtension fileExtension: String = "txt") -> String? {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    guard let filePath = bundle?.path(forResource: file, ofType: fileExtension) else {
        print("\(file).\(fileExtension) not found")
        return nil
    }
    
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines).filter { $0.isEmpty == false }
        return lines.first
    } catch {
        print("Contents could not be loaded")
    }
        
    return nil
}

func findStartOfFirstPacketMarker(inFile file: String, packetLength: Int) -> Int? {
    guard let data = readData(fromFile: file), data.count >= packetLength else {
        return nil
    }
    
    var start = data.startIndex
    var end = data.index(start, offsetBy: packetLength)
    for i in 0..<data.count - packetLength {
        let packetCharSet = Set(data[start..<end])
        if packetCharSet.count == packetLength {
            return i + packetLength
        }
        start = data.index(after: start)
        end = data.index(after: end)
    }
    
    return nil
}

// MARK: - Part 1

func part1() {
    guard let index = findStartOfFirstPacketMarker(inFile: "input", packetLength: 4) else {
        print("Start of packet marker was not found.")
        return
    }
    print("Start of packet marker found after character: \(index)")
}

// MARK: - Part 2

func part2() {
    guard let index = findStartOfFirstPacketMarker(inFile: "input", packetLength: 14) else {
        print("Start of packet marker was not found.")
        return
    }
    print("Start of packet marker found after character: \(index)")
}


part1()
part2()
