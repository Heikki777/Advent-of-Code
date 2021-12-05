import Foundation

infix operator -|-

enum LineDirection {
    case diagonal
    case vertical
    case horizontal
}

struct Line: Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(points)
    }
        
    // Returns a set of points where these two lines intersect
    static func -|- (line1: Line, line2: Line) -> Set<Point> {
        return line1.points.intersection(line2.points)
    }
    
    static func == (line1: Line, line2: Line) -> Bool {
        return line1.points == line2.points
    }
    
    var pointA: Point
    var pointB: Point
    var points: Set<Point> = Set()
    var lineDirection: LineDirection?
    
    init?(a: Point, b: Point, acceptedLineDirections: Set<LineDirection>) {

        if (a.x == b.x || a.y == b.y) && (a.x != b.x || a.y != b.y) {
            if a.y == b.y {
                guard acceptedLineDirections.contains(.horizontal) else { return nil }
                lineDirection = .horizontal
            } else if a.x == b.x {
                guard acceptedLineDirections.contains(.vertical) else { return nil }
                lineDirection = .vertical
            }
        } else if (abs(a.x - b.x) == abs(a.y - b.y) && (abs(a.x - b.x) > 0 || abs(a.y - b.y) > 0)) {
            guard acceptedLineDirections.contains(.diagonal) else { return nil }
            lineDirection = .diagonal
        } else {
            return nil
        }
        
        self.pointA = a
        self.pointB = b
        
        switch lineDirection {
        case .diagonal:
            var x = a.x
            var y = a.y
            let dx = (a.x < b.x) ? 1 : -1
            let dy = (a.y < b.y) ? 1 : -1
            let steps = abs(a.x - b.x)
            for _ in 0...steps {
                points.insert(Point(x: x, y: y))
                x += dx
                y += dy
            }
        case .vertical:
            let minY = min(a.y, b.y)
            let maxY = max(a.y, b.y)
            for y in minY...maxY {
                points.insert(Point(x: a.x, y: y))
            }
        case .horizontal:
            let minX = min(a.x, b.x)
            let maxX = max(a.x, b.x)
            for x in minX...maxX {
                points.insert(Point(x: x, y: a.y))
            }
        default:
            break
        }
    }
}
