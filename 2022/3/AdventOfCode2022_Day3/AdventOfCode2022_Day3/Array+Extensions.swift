//
//  Array+Extensions.swift
//  AdventOfCode2022_Day3
//
//  Created by Hämälistö Heikki on 3.12.2022.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
