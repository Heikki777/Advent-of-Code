import Foundation

func readLines(fromFile file: String) -> [Int] {
    
    if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
        do {
            return try String(contentsOfFile: filepath)
                .split(separator: "\n")
                .compactMap { Int($0) }
            
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func checkReport(_ report: [Int], windowSize: Int) {
    var increaseCount = 0
    var previousWindowSum: Int? = nil

    for i in 0...(report.count - windowSize) {
        
        var sum = 0
        for j in i..<(i+windowSize) {
            sum += report[j]
        }
                
        if let previousWindowSum = previousWindowSum, previousWindowSum < sum {
            increaseCount += 1
        }
        previousWindowSum = sum
    }

    print(increaseCount)
}

let report = readLines(fromFile: "input")

// Part 1
checkReport(report, windowSize: 1)

// Part 2
checkReport(report, windowSize: 3)
