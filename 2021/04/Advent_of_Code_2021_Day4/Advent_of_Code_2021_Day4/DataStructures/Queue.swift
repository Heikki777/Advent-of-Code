import Foundation

struct Queue<Element> {
    private var array = [Element]()

    var first: Element? { array.first }
    var last: Element? { array.last }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    mutating func append(_ element: Element) {
        array.append(element)
    }

    mutating func dequeue() -> Element? {
        guard array.count > 0 else { return nil }
        return array.remove(at: 0)
    }
}
