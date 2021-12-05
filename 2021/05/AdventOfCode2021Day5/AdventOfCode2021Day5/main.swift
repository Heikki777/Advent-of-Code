import Foundation

func readLines(fromFile file: String, acceptedLineDirections: Set<LineDirection>) -> [Line] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    if let filepath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filepath, encoding: .utf8)
            let inputLines = content.components(separatedBy: .newlines)
            let lineCoordinates = inputLines.compactMap {
                $0.replacingOccurrences(of: " -> ", with: " ", options: [], range: nil).split(separator: " ")
            }
            
            let lines = lineCoordinates.compactMap { c -> Line? in
                guard c.count == 2 else { return nil }
                let a = c[0].split(separator: ",")
                let b = c[1].split(separator: ",")
                guard let aX = Int(a[0]), let aY = Int(a[1]) else { return nil }
                guard let bX = Int(b[0]), let bY = Int(b[1]) else { return nil }
                let pointA = Point(x: aX, y: aY)
                let pointB = Point(x: bX, y: bY)
                return Line(a: pointA, b: pointB, acceptedLineDirections: acceptedLineDirections)
            }
            
            return lines
            
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func getPointsWhereLinesOverlap(acceptedLineDirections: Set<LineDirection>) -> Int {
    let lines = readLines(fromFile: "input", acceptedLineDirections: acceptedLineDirections)

    var linesAtIntersectionPoints: [Point: Set<Line>] = [:]
    for line in lines {
        for anotherLine in lines {
            
            guard line != anotherLine else {
                continue
            }
            
            let points = line -|- anotherLine
            
            for point in points {
                if linesAtIntersectionPoints[point] == nil {
                    linesAtIntersectionPoints[point] = Set<Line>()
                }
                linesAtIntersectionPoints[point]?.insert(line)
                linesAtIntersectionPoints[point]?.insert(anotherLine)
            }
        }
    }
    
    return linesAtIntersectionPoints.filter({ $0.value.count > 1 }).count
}

// PART 1
print(getPointsWhereLinesOverlap(acceptedLineDirections: Set<LineDirection>([.horizontal, .vertical])))

// PART 2
print(getPointsWhereLinesOverlap(acceptedLineDirections: Set<LineDirection>([.horizontal, .vertical, .diagonal])))



