//
//  main.swift
//  AdventOfCode2022_Day6
//
//  Created by Hämälistö Heikki on 6.12.2022.
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

func findStartOfPacketMarker(packetLength: Int) {
    guard let data = readData(fromFile: "input") else { return }
    var start = data.startIndex
    var end = data.index(start, offsetBy: packetLength)
    for i in 0..<data.count-packetLength {
        let packet = data[start..<end]
        let set = Set(packet)
        if set.count == packetLength {
            print("Start of packet marker found at character: \(i+packetLength)")
            break
        }
        start = data.index(after: start)
        end = data.index(after: end)
    }
}

// MARK: - Part 1

func part1() {
    findStartOfPacketMarker(packetLength: 4)
}

// MARK: - Part 2

func part2() {
    findStartOfPacketMarker(packetLength: 14)
}


part1()
part2()
