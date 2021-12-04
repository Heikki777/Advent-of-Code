import Foundation

class BingoGame {
    
    var randomNumbers: Queue<Int> = Queue()
    var bingoCards: [BingoCard] = []
    
    func readBingoData(fromFile file: String) {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "InputFiles.bundle", relativeTo: currentDirectoryURL)
        let bundle = Bundle(url: bundleURL)
        if let filepath = bundle?.path(forResource: file, ofType: "txt") {
            do {
                let content = try String(contentsOfFile: filepath, encoding: .utf8)
                
                parseInputData(data: content)
                
            } catch {
                print("Contents could not be loaded")
            }
        } else {
            print("\(file).txt not found")
        }
    }
    
    func drawNextNumber() -> Int? {
        return randomNumbers.dequeue()
    }
    
    func removeCard(_ card: BingoCard) {
        bingoCards.removeAll { $0 == card }
    }
    
    func checkNumber(_ number: Int) -> [BingoCard] {
        var winningCards: [BingoCard] = []
        for bingoCard in bingoCards {
            let hasBingo = bingoCard.checkNumber(number)
            if hasBingo {
                winningCards.append(bingoCard)
            }
        }
        
        // Sort the bingo cards: The card closest to bingo first
        bingoCards.sort {
            if $0.numbersRequiredToBingo == $1.numbersRequiredToBingo {
                return $0.markedNumbers > $1.markedNumbers
            }
            return $0.numbersRequiredToBingo < $1.numbersRequiredToBingo
        }
        
        return winningCards
    }
    
    private func parseInputData(data: String) {
        let lines = data.components(separatedBy: .newlines)
        guard lines.isEmpty == false else { return }
        
        var bingoCardRows: [[(Int, Bool)]] = []
        for (lineIndex, line) in lines.enumerated() {
            
            if lineIndex == 0 {
                line.split(separator: ",").compactMap { Int($0) }.forEach {
                    self.randomNumbers.append($0)
                }
            } else {
                if line.isEmpty {
                    if bingoCardRows.count == 5 {
                        if let bingoCard = BingoCard(rows: bingoCardRows) {
                            bingoCards.append(bingoCard)
                        } else {
                            print("Error! Invalid bingo card data")
                        }
                    }
                    bingoCardRows = []
                } else {
                    bingoCardRows.append(
                        line
                            .split(separator: " ")
                            .compactMap { Int($0) }
                            .map { (number: $0, checked: false )}
                    )
                }
            }
        }
    }
}
