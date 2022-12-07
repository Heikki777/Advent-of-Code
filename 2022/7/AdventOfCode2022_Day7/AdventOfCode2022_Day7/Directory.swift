//
//  Directory.swift
//  AdventOfCode2022_Day7
//
//  Created by Hämälistö Heikki on 7.12.2022.
//

import Foundation

class Directory: Comparable {
    var name: String = ""
    var parent: Directory?
    var directories: [String: Directory] = [:]
    var files: [File] = []
    
    static func < (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.size < rhs.size
    }
    
    static func > (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.size > rhs.size
    }
    
    static func == (lhs: Directory, rhs: Directory) -> Bool {
        return lhs.name == rhs.name && lhs.parent == rhs.parent
    }
    
    var size: Int {
        let totalSize = files.reduce(0) { $0 + $1.size }
        return totalSize + directories.values.reduce(0) { $0 + $1.size }
    }
    
    init(name: String) {
        self.name = name
    }
    
    func addDirectory(_ dir: Directory) {
        dir.parent = self
        directories[dir.name] = dir
    }
    
    func addFile(_ file: File) {
        files.append(file)
    }
}
