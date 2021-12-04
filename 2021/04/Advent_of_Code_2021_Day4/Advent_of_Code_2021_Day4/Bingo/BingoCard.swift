import Foundation

class BingoCard: Equatable {
    
    static func == (lhs: BingoCard, rhs: BingoCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    private let id = UUID()
    private var rows: [[(number: Int, isMarked: Bool)]] = []
    private(set) var markedNumbers = 0
    private(set) var numbersRequiredToBingo = 5
    
    private var rowCount: Int {
        return rows.count
    }
    
    private var columnCount: Int {
        return rows.first?.count ?? 0
    }
    
    var hasBingo: Bool {
        return numbersRequiredToBingo == 0
    }
    
    init?(rows: [[(Int, Bool)]]) {
        // Make sure that there are 5 rows, and each row contains 5 numbers.
        guard rows.count == 5 && (rows.allSatisfy { $0.count == 5 }) else {
            // Not valid bingo card data
            return nil
        }
        
        self.rows = rows
    }
    
    func checkNumber(_ search: Int) -> Bool {
        rowLoop: for (i, row) in rows.enumerated() {
            for (j, item) in row.enumerated() {
                if item.number == search {
                    rows[i][j].isMarked = true
                    self.markedNumbers += 1
                    break rowLoop
                }
            }
        }
        
        // Check rows
        for row in rows {
            numbersRequiredToBingo = min(numbersRequiredToBingo, row.filter { $0.isMarked == false }.count)
        }
        
        // Check columns
        for i in 0..<columnCount {
            var unmarkedNumbers = 0
            for row in rows {
                if row[i].isMarked == false {
                    unmarkedNumbers += 1
                }
            }
            numbersRequiredToBingo = min(numbersRequiredToBingo, unmarkedNumbers)
        }
        
        return self.numbersRequiredToBingo == 0
    }
    
    func sumOfUnmarkedNumbers() -> Int {
        var sum = 0
        for row in rows {
            for number in row {
                if number.isMarked == false {
                    sum += number.number
                }
            }
        }
        return sum
    }
}
