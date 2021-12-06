
import Foundation

func readLanternFishData(fromFile file: String) -> [UInt8] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    if let filepath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            guard let firstLine = lines.first else { return [] }
            
            return firstLine.split(separator: "," )
            .compactMap { UInt8($0) }
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func getLanternFishCount(afterDays days: Int) -> UInt64 {
    let lanternFishArray: [UInt8] = readLanternFishData(fromFile: "input")
    var lanternFishDayCount: [UInt64] = Array(repeating: UInt64(0), count: 9)

    for fishAge in lanternFishArray {
        lanternFishDayCount[Int(fishAge)] += 1
    }

    for _ in 1...days {
        var updated: [UInt64] = Array(repeating: UInt64(0), count: 9)
        for age in 0..<lanternFishDayCount.count {
            if age > 0 && age < 9 {
                updated[age-1] += lanternFishDayCount[age]
            } else if age == 0 {
                updated[6] += lanternFishDayCount[0]
                updated[8] += lanternFishDayCount[0]
            }
        }
        lanternFishDayCount = updated
    }

    let sum: UInt64 = lanternFishDayCount.reduce(0, +)
    return sum
}

// PART 1
print(getLanternFishCount(afterDays: 80))

// PART 2
print(getLanternFishCount(afterDays: 256))

