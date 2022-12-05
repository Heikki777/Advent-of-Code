//
//  Stack.swift
//  AdventOfCode2022_Day5
//
//  Created by Hämälistö Heikki on 5.12.2022.
//

import Foundation

struct Stack {
    private(set) var id: Int
    private(set) var crates: [Crate] = []
    
    init(id: Int, crates: [Crate] = []) {
        self.id = id
        self.crates = crates
    }
    
    mutating func push(crate: Crate) {
        crates.append(crate)
    }
    
    mutating func push(crateStack: [Crate]) {
        crates.append(contentsOf: crateStack)
    }
    
    mutating func addToBottom(crate: Crate) {
        crates.insert(crate, at: 0)
    }
    
    mutating func takeTop() -> Crate? {
        return crates.popLast()
    }
    
    mutating func takeTop(k: Int) -> [Crate] {
        let subStack = Array(crates.dropFirst(crates.count - k))
        crates.removeLast(k)
        return subStack
    }
    
    func peekTop() -> Crate? {
        return crates.last
    }
}
