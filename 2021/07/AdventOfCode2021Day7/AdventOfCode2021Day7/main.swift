
import Foundation

func readCrabData(fromFile file: String) -> [Int] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    if let filepath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            guard let firstLine = lines.first else { return [] }
            
            return firstLine.split(separator: "," )
            .compactMap { Int($0) }
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func sumOfFirstNaturalNumbers(n: Int) -> Int {
    return n * (n+1) / 2
}

func findOptimalHorizontalMove(forCrabs crabs: [Int], constantFuelRate: Bool = true) -> (move: Int?, fuel: Int?) {
    guard crabs.isEmpty == false else { return (nil, nil) }
    let average = crabs.reduce(0, +) / crabs.count
    let min = crabs.min()!
    let max = crabs.max()!
    let minAverageDifference = abs(average - min)
    let maxAverageDifference = abs(average - max)
    let sorted = crabs.sorted { (minAverageDifference < maxAverageDifference) ? $0 < $1 : $1 < $0 }
    
    var optimalMove: Int?
    var optimalFuelCost: Int?
    moveLoop: for move in 1...max {
        var fuel = 0
        crabLoop: for crab in sorted {
            let crabFuel = (constantFuelRate) ? abs(crab - move) : sumOfFirstNaturalNumbers(n: abs(crab - move))
            fuel += crabFuel
            if let optimalFuelCost = optimalFuelCost, fuel > optimalFuelCost {
                break crabLoop
            }
        }
        if let optimalFuelCost_ = optimalFuelCost {
            if fuel < optimalFuelCost_ {
                optimalFuelCost = fuel
                optimalMove = move
            }
        } else {
            optimalMove = move
            optimalFuelCost = fuel
        }
    }
    return (optimalMove, optimalFuelCost)

}

let crabs = readCrabData(fromFile: "input")
// PART 1
print("Optimal move with constant fuel rate: \(findOptimalHorizontalMove(forCrabs: crabs, constantFuelRate: true))")


// PART 2
print("Optimal move with increasing fuel rate: \(findOptimalHorizontalMove(forCrabs: crabs, constantFuelRate: false))")


