
import Foundation

func readOctopusData(fromFile file: String) -> [[Octopus]] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split(separator: "\n").map { String($0) }
            return lines.enumerated().map { y, line in
                line.enumerated().compactMap { x, energyChar in
                    guard let energy = Int(String(energyChar)) else { return nil }
                    return Octopus(y: y, x: x, energy: energy)
                }
            }
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func printGrid(_ grid: [[Octopus]]) {
    for row in grid {
        for octopus in row {
            print(octopus.energy, terminator: "")
        }
        print()
    }
    print()
}

func flashOctopuses(_ octopuses: [Octopus], in octopusGrid: [[Octopus]]) -> Int {
    guard let columnCount = octopusGrid.first?.count else { return 0 }
    var flashCount = 0
    for octopus in octopuses {
        if octopus.shouldFlash {
            octopus.flash()
            flashCount += 1
        }
        if octopus.flashed {
            for dy in -1...1 {
                for dx in -1...1 {
                    if dy == 0 && dx == 0 || octopus.y+dy < 0 || octopus.y+dy >= octopusGrid.count || octopus.x+dx < 0 || octopus.x+dx >= columnCount {
                        continue
                    }
                    octopusGrid[octopus.y+dy][octopus.x+dx].increaseEnergy()
                }
            }
        }
    }
    
    octopusGrid.flatMap { $0 }.filter { $0.flashed }.forEach { $0.resetEnergy() }
    let flashables = octopusGrid.flatMap { $0 }.filter { $0.shouldFlash }
    if flashables.isEmpty == false {
        return flashCount + flashOctopuses(flashables, in: octopusGrid)
    }
    octopusGrid.flatMap { $0 }.forEach { $0.resetFlash() }
    return flashCount
}

func part1() {
    let octopusGrid: [[Octopus]] = readOctopusData(fromFile: "input")
    let steps = 100
    var flashSum = 0
    for _ in 0..<steps {
        octopusGrid.flatMap { $0 }.forEach { $0.increaseEnergy() }
        let flashables = octopusGrid.flatMap { $0 }.filter { $0.shouldFlash }
        let stepFlashCount = flashOctopuses(flashables, in: octopusGrid)
        flashSum += stepFlashCount
    }
    print("After \(steps) steps, there have been a total of \(flashSum) flashes.")
}

func part2() {
    let octopusGrid: [[Octopus]] = readOctopusData(fromFile: "input")
    var stepCount = 0
    var stepFlashCount = 0
    let octopusCount = octopusGrid.flatMap { $0 }.count

    repeat {
        stepCount += 1
        octopusGrid.flatMap { $0 }.forEach { $0.increaseEnergy() }
        let flashables = octopusGrid.flatMap { $0 }.filter { $0.shouldFlash }
        stepFlashCount = flashOctopuses(flashables, in: octopusGrid)
    } while stepFlashCount != octopusCount

    print("At the step \(stepCount), all the octopuses flashed")

}

// PART 1
part1()

// PART 2
part2()
