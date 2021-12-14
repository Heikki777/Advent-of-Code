
import Foundation

func readData(from file: String) -> (template: String, rules: [(key: String, value: Character)])? {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            var lines = content.components(separatedBy: .newlines)
            let template = lines.removeFirst()
            guard !lines.isEmpty, lines.removeFirst().isEmpty else { return nil }
            
            let rules = lines.compactMap { rule -> (key: String, value: Character)? in
                let parts = rule.replacingOccurrences(of: " -> ", with: "-")
                    .split(separator: "-")
                guard parts.count == 2 else { return nil }
                return (key: String(parts[0]), value: Character(String(parts[1])))
            }
            return (template, rules)
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return nil
}

func applyPairInsertions(to template: String, withRules rules: [(key: String, value: Character)], steps: Int) {
    var charCount: [Character: Int] = [:]
    var pairs: [String: Int] = [:]
    for char in template {
        if charCount[char] == nil {
            charCount[char] = 0
        }
        charCount[char]! += 1
    }
    
    for i in 0..<template.count {
        for rule in rules {
            guard i+2 <= template.count else { continue }
            let start = template.index(template.startIndex, offsetBy: i)
            let end = template.index(template.startIndex, offsetBy: i+2)
            if template[start..<end] == rule.key {
                if pairs[rule.key] == nil {
                    pairs[rule.key] = 0
                }
                pairs[rule.key]! += 1
            }
        }
    }
    
    for _ in 0..<steps {
        
        var changes: [String : Int] = [:]
        
        for (pair, count) in pairs {
            guard let rule = rules.first(where: { $0.key == pair }) else { continue }
            let newPair = "\(rule.key.first!)\(rule.value)"
            let newPair2 = "\(rule.value)\(rule.key.last!)"
            
            charCount[rule.value] = (charCount[rule.value] ?? 0) + count

            if changes[pair] == nil {
                changes[pair] = -count

            } else {
                changes[pair]! -= count
            }
            
            for newPair in [newPair, newPair2] {
                if changes[newPair] == nil {
                    changes[newPair] = count
                } else {
                    changes[newPair]! += count
                }
            }
        }
        
        for change in changes {
            if pairs[change.key] == nil {
                pairs[change.key] = max(0, change.value)
            } else {
                pairs[change.key] = max(0, pairs[change.key]! + change.value)
            }
        }
    }
    
    let sortedCharFrequency = charCount.sorted(by: { $0.value > $1.value })
    if let mostCommon = sortedCharFrequency.first, let leastCommon = sortedCharFrequency.last {
        print(mostCommon.value - leastCommon.value)
    }
}

if let (template, rules) = readData(from: "input") {
    // PART 1
    applyPairInsertions(to: template, withRules: rules, steps: 10)

    // PART 2
    applyPairInsertions(to: template, withRules: rules, steps: 40)
}
