//
//  main.swift
//  AdventOfCode2022_Day7
//
//  Created by Hämälistö Heikki on 7.12.2022.
//

import Foundation

func readData(fromFile file: String, withExtension fileExtension: String = "txt") -> [String] {
    
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
        return lines
    } catch {
        print("Contents could not be loaded")
    }
        
    return []
}

func createFileSystem(fromTerminalOutput lines: [String]) -> Directory? {
    var fileSystem: Directory?
    var currentDirectory: Directory?
    var previousCommand: Command?
    
    for line in lines {
        let splitted = line
            .split(separator: " ")
            .map { String($0) }
        
        if splitted.first == "$" {
            
            // MARK: - Input line
            
            guard splitted.count >= 2 else {
                print("ERROR! Invalid command")
                continue
            }
            
            guard let command = Command(rawValue: splitted[1]) else {
                print("ERROR! Unknown command")
                continue
            }

            switch command {
            case .changeDirectory:
                guard splitted.count >= 3 else {
                    print("ERROR! Invalid command")
                    continue
                }

                switch splitted[2] {
                case "..":
                    // Move up to the parent directory
                    if let parent = currentDirectory?.parent {
                        currentDirectory = parent
                    }
                    break
                default:
                    let newDirectory = Directory(name: splitted[2])
                    if fileSystem == nil {
                        fileSystem = newDirectory
                    }
                    currentDirectory?.addDirectory(newDirectory)
                    currentDirectory = newDirectory
                }
                
                fallthrough
                
            default:
                previousCommand = command
            }
            
        } else {
            // MARK: - Output line
            if previousCommand == .list {
                // Output line for the list (ls) command.
                guard splitted.count >= 2 else { continue }
                switch splitted[0] {
                case "dir":
                    // Directory
                    let name = splitted[1]
                    let newDirectory = Directory(name: name)
                    currentDirectory?.addDirectory(newDirectory)
                default:
                    // File
                    if let fileSize = Int(splitted[0]) {
                        let fileName = splitted[1]
                        let file = File(name: fileName, size: fileSize)
                        currentDirectory?.addFile(file)
                    }
                }
            }
        }
    }
    return fileSystem
}

func printDirectory(_ dir: Directory, depth: Int = 0) {
    let indent = String.init(repeating: "   ", count: max(0, depth-1)) + ((depth > 0) ? (" - ") : "")
    print("\(indent)Directory: \(dir.name). Content: \(dir.directories.count) sub directories and \(dir.files.count) files. Total size: \(dir.size)")
    for file in dir.files {
        let fileIndent = String.init(repeating: "   ", count: max(0, depth)) + " - "
        print("\(fileIndent)File: \(file.name), size: \(file.size)")
    }
    for subDirectory in dir.directories {
        printDirectory(subDirectory.value, depth: depth + 1)
    }
}

func findDirectories(dir: Directory, withMaxTotalSize maxTotalSize: Int) -> [Directory] {
    var result: [Directory] = []
    if dir.size <= maxTotalSize {
        result.append(dir)
    }
    for subDirectory in dir.directories.values {
        result += findDirectories(dir: subDirectory, withMaxTotalSize: maxTotalSize)
    }
    return result
}

func getDirectories(dir: Directory) -> [Directory] {
    var result = [dir]
    for subDir in dir.directories.values {
        result.append(contentsOf: getDirectories(dir: subDir))
    }
    return result
}

func findSmallestRemovableDirectoryToFreeDiskSpace(dir: Directory, requiredDiskSpace: Int) -> Directory? {
    return getDirectories(dir: dir)
        .sorted(by: <)
        .first(where: { $0.size > requiredDiskSpace })
}

let lines = readData(fromFile: "input")
let fileSystem = createFileSystem(fromTerminalOutput: lines)


// MARK: - Part 1

func part1() {
    print("------- PART 1 -------")
    if let fileSystem = fileSystem {
        let result = findDirectories(dir: fileSystem, withMaxTotalSize: 100_000).reduce(0) { $0 + $1.size }
        print(result)
    }
}


// MARK: - Part 2

func part2() {
    print("\n------- PART 2 -------")
    if let fileSystem = fileSystem {
        let totalDiskSpace = 70_000_000
        let requiredDiskSpaceForUpdate = 30_000_000
        let unusedDiskSpace = totalDiskSpace - fileSystem.size
        let additionalFreeDiskSpaceRequired = requiredDiskSpaceForUpdate - unusedDiskSpace
        
        guard additionalFreeDiskSpaceRequired > 0 else { return }
        
        if let directoryToRemove = findSmallestRemovableDirectoryToFreeDiskSpace(dir: fileSystem, requiredDiskSpace: additionalFreeDiskSpaceRequired) {
            print(directoryToRemove.size)
        }
    }
}


part1()
part2()
