
import Foundation

func readData(fromFile file: String) -> [String] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    if let filepath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = content.split(separator: "\n").compactMap { String($0) }
            return lines
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func part1() {
    let segmentLengthToDigitDictionary: [Int:Int] = [2:1, 4:4, 3:7, 7:8]
    let lines = readData(fromFile: "input")
    let outputValues = lines.compactMap { $0.split(separator: "|")[1].trimmingCharacters(in:CharacterSet([" "])) }

    // PART 1
    var result: Int = 0
    for outputValue in outputValues {
        let segments = outputValue.split(separator: " ")
        for segment in segments {
            if let _ = segmentLengthToDigitDictionary[segment.count] {
                result += 1
            }
        }
    }
    print(result)

}

// PART 2
func part2() {
    let lines = readData(fromFile: "input")
    let signalPatterns = lines.compactMap { $0.split(separator: "|")[0].trimmingCharacters(in:CharacterSet([" "])) }
    let outputValuesArray = lines.compactMap { $0.split(separator: "|")[1].trimmingCharacters(in:CharacterSet([" "])) }
    var outputSum = 0
    
    for (rowIndex, signalPattern) in signalPatterns.enumerated() {
        let outputValues = outputValuesArray[rowIndex].split(separator: " ").compactMap { String($0) }
        let decoded = decodeSignalPattern(signalPattern)
        var output = ""
        
        for outputValue in outputValues {
            decodedLoop: for (digit, value) in decoded.enumerated() {
                if Set<Character>(value) == Set<Character>(outputValue) {
                    output += "\(digit)"
                    break decodedLoop
                }
            }
        }
        outputSum += Int(output) ?? 0
    }
    print(outputSum)
}

func decodeSignalPattern(_ signalPattern: String) -> [String] {
    var decoded = Array.init(repeating: "", count: 10)
    let digits = signalPattern.split(separator: " ").compactMap { String($0) }
    let segmentLengthToDigitDictionary: [Int:Int] = [2:1, 4:4, 3:7, 7:8]

    // 1, 4, 7, 8
    for digit in digits {
        guard let digitNubmer = segmentLengthToDigitDictionary[digit.count] else { continue }
        decoded[digitNubmer] = digit
    }
    
    // 9
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[9].isEmpty && digit.count == 6
            && Set<Character>(decoded[4]).intersection(digitCharSet).count == 4 {
            decoded[9] = digit
        }
    }
    
    // 6
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[6].isEmpty && digit.count == 6
            && Set<Character>(decoded[9]).intersection(digitCharSet).count == 5
            && Set<Character>(decoded[1]).intersection(digitCharSet).count == 1 {
            decoded[6] = digit
        }
    }
    
    // 0
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[0].isEmpty && digit.count == 6
            && Set<Character>(decoded[8]).intersection(digitCharSet).count == 6
            && Set<Character>(decoded[4]).intersection(digitCharSet).count == 3
            && Set<Character>(decoded[7]).intersection(digitCharSet).count == 3
            && Set<Character>(decoded[1]).intersection(digitCharSet).count == 2 {
            decoded[0] = digit
        }
    }
    
    // 5
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[5].isEmpty && digit.count == 5
            && Set<Character>(decoded[8]).intersection(digitCharSet).count == 5
            && Set<Character>(decoded[4]).intersection(digitCharSet).count == 3
            && Set<Character>(decoded[7]).intersection(digitCharSet).count == 2
            && Set<Character>(decoded[1]).intersection(digitCharSet).count == 1 {
            decoded[5] = digit
        }
    }
    
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[3].isEmpty && digit.count == 5
            && Set<Character>(decoded[8]).intersection(digitCharSet).count == 5
            && Set<Character>(decoded[4]).intersection(digitCharSet).count == 3
            && Set<Character>(decoded[7]).intersection(digitCharSet).count == 3
            && Set<Character>(decoded[1]).intersection(digitCharSet).count == 2 {
            decoded[3] = digit
        }
    }
    
    for digit in digits {
        let digitCharSet = Set<Character>(digit)
        if decoded[2].isEmpty && digit.count == 5
            && Set<Character>(decoded[8]).intersection(digitCharSet).count == 5
            && Set<Character>(decoded[4]).intersection(digitCharSet).count == 2
            && Set<Character>(decoded[7]).intersection(digitCharSet).count == 2
            && Set<Character>(decoded[1]).intersection(digitCharSet).count == 1 {
            decoded[2] = digit
        }
    }
    
    return decoded
}

part1()

part2()


