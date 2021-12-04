import Foundation

func findFirstWinningBingoCard() {
    let bingoGame: BingoGame = BingoGame()
    bingoGame.readBingoData(fromFile: "input")
    while let number = bingoGame.drawNextNumber() {
        let winningCards = bingoGame.checkNumber(number)
        if let winningCard = winningCards.first {
            print(winningCard.sumOfUnmarkedNumbers() * number)
            break
        }
    }
}

func findLastWinningBingoCard() {
    let bingoGame: BingoGame = BingoGame()
    bingoGame.readBingoData(fromFile: "input")
    gameLoop: while let number = bingoGame.drawNextNumber() {
        let winningCards = bingoGame.checkNumber(number)
        for winningCard in winningCards {
            bingoGame.removeCard(winningCard)
            if bingoGame.bingoCards.isEmpty {
                print(winningCard.sumOfUnmarkedNumbers() * number)
                break gameLoop
            }
        }
    }
}

// PART 1
findFirstWinningBingoCard()

// PART 2
findLastWinningBingoCard()

