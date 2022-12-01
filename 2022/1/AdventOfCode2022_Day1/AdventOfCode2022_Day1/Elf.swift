//
//  Elf.swift
//  AdventOfCode2022_Day1
//
//  Created by Hämälistö Heikki on 1.12.2022.
//

import Foundation

struct Elf: Comparable {
    static func < (lhs: Elf, rhs: Elf) -> Bool {
        return lhs.totalCalories < rhs.totalCalories
    }
    
    static func >(lhs: Elf, rhs: Elf) -> Bool {
        return lhs.totalCalories > rhs.totalCalories
    }
    
    var foodItemCalories: [Int] = []
    
    var totalCalories: Int {
        return foodItemCalories.reduce(0, +)
    }
}
