
import Foundation

let openClosePairDict: [Character:Character] = [
    "(":")",
    "{":"}",
    "[":"]",
    "<":">"
]

let closeOpenPairDict: [Character:Character] = [
    ")":"(",
    "}":"{",
    "]":"[",
    ">":"<"
]

let openingChars = Array(openClosePairDict.keys)
let closingChars = Array(openClosePairDict.values)
var closing: [Character] = []

func readData(fromFile file: String) -> [String] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split(separator: "\n").map { String($0) }
            return lines
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func calculateSyntaxErrorScore(inLines lines: [String]) -> Int {
    closing = []
    let pointDictionary: [Character:Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
    var syntaxErrorScore = 0
    for line in lines {
        if let illegalChar = findFirstIllegalCharacter(Array(line)) {
            syntaxErrorScore += pointDictionary[illegalChar]!
        }
    }
    return syntaxErrorScore
}

func calculateMiddleScore(inLines lines: [String]) -> Int {
    closing = []
    let pointDictionary: [Character:Int] = [")": 1, "]": 2, "}": 3, ">": 4]
    var points: [Int] = []
    var isValid = false
    for line in lines {
        var score = 0
        let chars = Array(line)
        for i in 0..<chars.count {
            if isOpening(chars[i]) {
                closing.append(pair(forChar: chars[i]))
            } else {
                isValid = validateClosing(chars[i])
                if !isValid {
                    break
                }
                closing.removeLast()
            }
        }
        if isValid {
            closing.reversed().forEach { char in
                score *= 5
                score += pointDictionary[char]!
            }
            points.append(score)
        }
        closing = []
    }
    
    let middleScore = points.sorted(by: <)[(points.count - 1) / 2]
    
    return middleScore
}

func isOpening(_ char: Character) -> Bool {
    return openingChars.contains(char)
}

func pair(forChar char: Character) -> Character {
    if openingChars.contains(char) {
        return openClosePairDict[char]!
    } else {
        return closeOpenPairDict[char]!
    }
}

func validateClosing(_ char: Character) -> Bool {
    if let closingLast = closing.last, closingLast == char {
        return true
    }
    return false
}

func findFirstIllegalCharacter(_ line: [Character]) -> Character? {
    for i in 0..<line.count {
        if isOpening(line[i]) {
            closing.append(pair(forChar: line[i]))
        } else {
            let isValidClosing = validateClosing(line[i])
            if isValidClosing {
                closing.removeLast()
            } else {
                return line[i]
            }
        }
    }
    return nil
}

func part1() {
    let lines = readData(fromFile: "input")
    let syntaxErrorScore = calculateSyntaxErrorScore(inLines: lines)
    print(syntaxErrorScore)
}

func part2() {
    let lines = readData(fromFile: "example")
    let middleScore = calculateMiddleScore(inLines: lines)
    print(middleScore)
}

part1()
part2()
