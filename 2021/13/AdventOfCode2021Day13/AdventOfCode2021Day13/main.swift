import Foundation

struct Point {
    var x: Int
    var y: Int
}

struct FoldingInstruction {
    var axis: Character
    var index: Int
}

func readData(fromFile file: String) -> (points: [Point], instructions: [FoldingInstruction])? {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            let parts = lines.split(separator: "")
            guard parts.count == 2 else { return nil }
            
            var points: [Point] = []
            for line in parts[0] {
                let xy = line.split(separator: ",").compactMap { Int($0) }
                guard xy.count == 2 else { continue }
                points.append(Point(x: xy[0], y: xy[1]))
            }
            
            var instructions: [FoldingInstruction] = []
            for line in parts[1] {
                let instruction = line.split(separator: "=")
                guard instruction.count == 2, let axis = instruction[0].last, let index = Int(instruction[1]) else { continue }
                instructions.append(FoldingInstruction(axis: axis, index: index))
            }
            
            return (points: points, instructions: instructions)
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return nil
}

func createPaper(maxY: Int, maxX: Int, points: [Int: [Point]]) -> [[Bool]] {
    var paper: [[Bool]] = []
    for y in 0...maxY {
        paper.append([])
        let pointsInRow = points[y] ?? []
        for x in 0...maxX {
            paper[y].append(pointsInRow.contains(where: { $0.x == x }))
        }
    }
    
    return paper
}

func printPaper(_ paper: [[Bool]]) {
    let printable = paper.map { $0.map { $0 ? Character("#") : Character("•") } }
    for row in printable {
        for char in row {
            print(" \(char)", terminator: "")
        }
        print()
    }
    print()
}

func foldPaper(_ paper: inout [[Bool]], using fold: FoldingInstruction) {
    if fold.axis == "y" {
        paper.remove(at: fold.index)
        let topHalf = paper.enumerated().filter { $0.offset < fold.index }.map { $0.element }
        var bottomHalf = paper.enumerated().filter { $0.offset >= fold.index }.map { $0.element }
        bottomHalf.reverse()
        
        var result = topHalf.count > bottomHalf.count ? topHalf : bottomHalf
        let smallerHalf = topHalf.count <= bottomHalf.count ? topHalf : bottomHalf
        let diff = abs(result.count - smallerHalf.count)
        
        for (i, row) in smallerHalf.enumerated() {
            for x in 0..<row.count {
                result[diff+i][x] = result[diff+i][x] || row[x]
            }
        }
        paper = result
    } else {
        var transposedPaper = paper.transposed()
        foldPaper(&transposedPaper, using: FoldingInstruction(axis: "y", index: fold.index))
        paper = transposedPaper.transposed()
    }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map { $0[index] }
        }
    }
}

// PART 1
if let (points, foldingInstructions) = readData(fromFile: "input") {
    let maxY = points.reduce(0, { max($0, $1.y) })
    let maxX = points.reduce(0, { max($0, $1.x) })
    let pointDictionary = Dictionary(grouping: points, by: { $0.y })
    var paper = createPaper(maxY: maxY, maxX: maxX, points: pointDictionary)
    
    if let firstFoldingInstruction = foldingInstructions.first {
        foldPaper(&paper, using: firstFoldingInstruction)
        let count = paper.flatMap { $0 }.filter { $0 }.count
        print(count)
    }
}

// PART 2
if let (points, foldingInstructions) = readData(fromFile: "input") {
    let maxY = points.reduce(0, { max($0, $1.y) })
    let maxX = points.reduce(0, { max($0, $1.x) })
    let pointDictionary = Dictionary(grouping: points, by: { $0.y })
    var paper = createPaper(maxY: maxY, maxX: maxX, points: pointDictionary)
    
    for foldingInstruction in foldingInstructions {
        foldPaper(&paper, using: foldingInstruction)
    }
    
    printPaper(paper)
}

