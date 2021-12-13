import Foundation

class Vertex: Hashable, Equatable, CustomStringConvertible {
    
    let value: String
    
    var description: String {
        return value
    }
    
    // MARK: - Equatable
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value
    }

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    init(value: String) {
        self.value = value
    }
}
