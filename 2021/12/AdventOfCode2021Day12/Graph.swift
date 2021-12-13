
import Foundation

class Graph {
    
    private(set) var vertices: Set<Vertex>
    private(set) var edges: [(v1: Vertex, v2: Vertex)] = []
        
    init(vertices: Set<Vertex>, edges: [Edge]) {
        self.vertices = vertices
        self.edges = edges
    }
    
    func printGraph() {
        Swift.print("Graph: vertices: \(vertices)")
        Swift.print("edges: ")
        for edge in edges {
            Swift.print("\(edge.v1) <-> \(edge.v2)")
        }
    }
    
    func adjacents(of vertex: Vertex) -> [Vertex] {
        var vertices: [Vertex] = []
        for edge in edges {
            if edge.v1 == vertex {
                vertices.append(edge.v2)
            } else if edge.v2 == vertex {
                vertices.append(edge.v1)
            }
        }
        return vertices
    }
    
    func isVisitable(_ v: Vertex, visited: [Vertex: Int], maxVisits: [Vertex: Int]) -> Bool {
        let visits: Int = visited[v] ?? 0
        if let maxVisits = maxVisits[v] {
            return visits < maxVisits
        }
        return true
    }
    
    private func allPaths(from start: Vertex, to goal: Vertex, visited: inout [Vertex: Int], maxVisits: [Vertex: Int], path: inout [Vertex], paths: inout Set<[Vertex]>) {
        
        if isVisitable(start, visited: visited, maxVisits: maxVisits) {
            visited[start] = (visited[start] ?? 0) + 1
        }

        path.append(start)
        
        if start == goal {
            paths.insert(path)
        } else {
            let visitableAdjacents = adjacents(of: start).filter { isVisitable($0, visited: visited, maxVisits: maxVisits) }
            for adjacent in visitableAdjacents {
                allPaths(from: adjacent, to: goal, visited: &visited, maxVisits: maxVisits, path: &path, paths: &paths)
            }
        }
        
        path.removeLast()
        visited[start] = (visited[start] ?? 1) - 1
    }
    
    func findAllPaths(from: Vertex, to: Vertex, maxVisits: [Vertex: Int]) -> Set<[Vertex]> {
        var visited: [Vertex: Int] = [:]
        for vertex in vertices {
            visited[vertex] = 0
        }
        
        var path: [Vertex] = []
        var paths: Set<[Vertex]> = Set()
        
        allPaths(from: from, to: to, visited: &visited, maxVisits: maxVisits, path: &path, paths: &paths)
        return paths
    }
}
