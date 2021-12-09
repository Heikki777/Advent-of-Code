
import Foundation

struct Point: Hashable {
    
    static func == (lhs:Point, rhs:Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.number == rhs.number
    }
    
    var y: Int
    var x: Int
    var number: Int
}

func readHeightMapData(fromFile file: String) -> [[Int]] {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split(separator: "\n").map { String($0) }
            return lines.map { line in
                line.map { String($0) }.compactMap { Int($0) }
            }
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return []
}

func printHeightMap(_ heightMap: [[Int]]) {
    for row in heightMap {
        for number in row {
            print("\(number)", terminator: "")
        }
        print()
    }
}

func findLowPoints(in heightMap: [[Int]]) -> [Point] {
    var result: [Point] = []
    
    rowLoop: for (i, row) in heightMap.enumerated() {
        numberLoop: for (j, number) in row.enumerated() {
            // Check adjacents
            
            // Up
            if i > 0 {
                if number >= heightMap[i-1][j] {
                    continue numberLoop
                }
            }
            
            // Left
            if j > 0 {
                if number >= heightMap[i][j-1] {
                    continue numberLoop
                }
            }
            
            // Down
            if i < heightMap.count - 1 {
                if number >= heightMap[i+1][j] {
                    continue numberLoop
                }
            }
            
            // Right
            if j < row.count - 1 {
                if number >= heightMap[i][j+1] {
                    continue numberLoop
                }
            }
            
            // Is low point
            result.append(Point(y: i, x:j, number: number))
        }
    }
    return result
}

func findBasins(in heightMap: [[Int]]) -> [Set<Point>] {
    
    let lowPoints = findLowPoints(in: heightMap)
    var basins: [Set<Point>] = []
    
    for lowPoint in lowPoints {
        let basin: Set<Point> = exploreBasin(point: lowPoint, in: heightMap)
        if basin.isEmpty == false {
            basins.append(basin)
        }
    }
    
    return basins
}

func exploreBasin(point: Point, in heightMap: [[Int]]) -> Set<Point> {
    var basin: Set<Point> = Set<Point>([point])

    // Up
    if point.y > 0 {
        let adjacentUp = heightMap[point.y-1][point.x]
        if point.number < adjacentUp && adjacentUp < 9 {
            let new = Point(y: point.y-1, x: point.x, number: adjacentUp)
            basin = basin.union(exploreBasin(point: new, in: heightMap))
        }
    }
    
    // Left
    if point.x > 0 {
        let adjacentLeft = heightMap[point.y][point.x-1]
        if point.number < adjacentLeft && adjacentLeft < 9 {
            let new = Point(y: point.y, x: point.x-1, number: adjacentLeft)
            basin = basin.union(exploreBasin(point: new, in: heightMap))
        }
    }
    
    // Down
    if point.y < heightMap.count - 1 {
        let adjacentDown = heightMap[point.y+1][point.x]
        if point.number < adjacentDown && adjacentDown < 9 {
            let new = Point(y: point.y+1, x: point.x, number: adjacentDown)
            basin = basin.union(exploreBasin(point: new, in: heightMap))
        }
    }
    
    // Right
    if point.x < heightMap[point.y].count - 1 {
        let adjacentRight = heightMap[point.y][point.x+1]
        if point.number < adjacentRight && adjacentRight < 9 {
            let new = Point(y: point.y, x: point.x+1, number: adjacentRight)
            basin = basin.union(exploreBasin(point: new, in: heightMap))
        }
    }
    
    return basin
}

let heightMap = readHeightMapData(fromFile: "input")

// PART 1
let lowPoints = findLowPoints(in: heightMap)
let sumOfRiskLevels = lowPoints.map { $0.number + 1 }.reduce(0, +)
print(lowPoints)
print(sumOfRiskLevels)

// PART 2
let basins = findBasins(in: heightMap).sorted { $0.count > $1.count }
if basins.count >= 3 {
    let product = basins[0...2].reduce(1) { $0 * $1.count }
    print(product)
}
