
import Foundation

typealias Edge = (v1: Vertex, v2: Vertex)

func readGraphData(fromFile file: String) -> (vertices: Set<Vertex>, edges: [(v1: Vertex, v2: Vertex)])? {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split(separator: "\n").map { String($0) }
            let edges: [(v1: Vertex, v2: Vertex)] = lines.compactMap {
                let vertices = $0.split(separator: "-").map { Vertex(value: String($0)) }
                guard vertices.count == 2 else { return nil }
                let edge = (v1: vertices[0], v2: vertices[1])
                return edge
            }
            let vertices: Set<Vertex> = Set(edges.map { [$0.v1, $0.v2] }.flatMap { $0 })
            return (vertices, edges)
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    return nil
}

extension Vertex {
    var isBig: Bool {
        return self.value.first?.isUppercase ?? false
    }

    var isSmall: Bool {
        return self.value.first?.isLowercase ?? false
    }

    var isStart: Bool {
        return self.value == "start"
    }

    var isEnd: Bool {
        return self.value == "end"
    }
}

func part1() {
    if let (vertices, edges) = readGraphData(fromFile: "input") {
        let graph = Graph(vertices: vertices, edges: edges)
        var allPaths = Set<[Vertex]>()

        if let start = graph.vertices.first(where: { $0.value == "start" }),
        let end = graph.vertices.first(where: { $0.value == "end" }) {
            var maxVisits: [Vertex: Int] = [start:1, end:1]
            let smallCaves = graph.vertices.filter { $0.isSmall && $0.isEnd == false && $0.isStart == false }
            smallCaves.forEach { maxVisits[$0] = 1 }
            allPaths = allPaths.union(graph.findAllPaths(from: start, to: end, maxVisits: maxVisits))
        }
        print(allPaths.count)
    }
}

func part2() {
    if let (vertices, edges) = readGraphData(fromFile: "input") {
        let graph = Graph(vertices: vertices, edges: edges)
        var allPaths = Set<[Vertex]>()

        if let start = graph.vertices.first(where: { $0.value == "start" }),
        let end = graph.vertices.first(where: { $0.value == "end" }) {

            var maxVisits: [Vertex: Int] = [start:1, end:1]
            let smallCaves = graph.vertices.filter { $0.isSmall && $0.isEnd == false && $0.isStart == false }
            
            for smallCave in smallCaves {
                smallCaves.forEach {
                    maxVisits[$0] = 1 // The small caves can be visited once...
                }
                maxVisits[smallCave] = 2 // ..., but a single small cave can be visited twice
                allPaths = allPaths.union(graph.findAllPaths(from: start, to: end, maxVisits: maxVisits))
            }
        }
        print(allPaths.count)
    }
}

// PART 1
part1()

// PART 2
part2()
