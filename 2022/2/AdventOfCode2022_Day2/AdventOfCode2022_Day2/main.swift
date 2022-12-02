//
//  main.swift
//  AdventOfCode2022_Day2
//
//  Created by Hämälistö Heikki on 2.12.2022.
//

import Foundation

func readPlayerMoves(fromFile file: String) -> [RPSRound] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
        
            let rounds = lines.compactMap { line -> RPSRound? in
                guard line.isEmpty == false else { return nil }
                let components = line.split(separator: " ")
                guard components.count == 2 else { return nil }
                guard
                    let opponentMove = OpponentMove(rawValue: String(components[0])),
                    let playerMove = PlayerMove(rawValue: String(components[1]))
                else {
                    return nil
                }
                return RPSRound(opponentMove: opponentMove, playerMove: playerMove)
            }

            return rounds
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}


func readOpponentMoveAndDesiredOutcome(fromFile file: String) -> [(opponentMove: OpponentMove, result: RPSRoundResult)] {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Main.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    
    if let filePath = bundle?.path(forResource: file, ofType: "txt") {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
        
            let rounds = lines.compactMap { line -> (opponentMove: OpponentMove, result: RPSRoundResult)? in
                guard line.isEmpty == false else { return nil }
                let components = line.split(separator: " ")
                guard components.count == 2 else { return nil }
                guard
                    let opponentMove = OpponentMove(rawValue: String(components[0])),
                    let desiredOutcome = RPSRoundResult(code: String(components[1]))
                else {
                    return nil
                }
                return (opponentMove: opponentMove, result: desiredOutcome)
            }

            return rounds
        } catch {
            print("Contents could not be loaded")
        }
    } else {
        print("\(file).txt not found")
    }
    
    return []
}

enum RPSShape: Int, Comparable {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    init(opponentMove: OpponentMove) {
        switch opponentMove {
        case .rock:
            self = .rock
        case .paper:
            self = .paper
        case .scissors:
            self = .scissors
        }
    }
    
    init(playerMove: PlayerMove) {
        switch playerMove {
        case .rock:
            self = .rock
        case .paper:
            self = .paper
        case .scissors:
            self = .scissors
        }
    }
    
    static func <(lhs: RPSShape, rhs: RPSShape) -> Bool {
        if lhs == rhs {
            return false
        }
        if lhs == .rock {
            return rhs == .paper
        } else if lhs == .paper {
            return rhs == .scissors
        } else {
            return rhs == .rock
        }
    }
    
    static func >(lhs: RPSShape, rhs: RPSShape) -> Bool {
        return rhs < lhs
    }
}

enum OpponentMove: String, CaseIterable {
    case rock = "A"
    case paper = "B"
    case scissors = "C"
    
    var shape: RPSShape {
        return RPSShape(opponentMove: self)
    }
}

enum PlayerMove: String, CaseIterable {
    case rock = "X"
    case paper = "Y"
    case scissors = "Z"
    
    var shape: RPSShape {
        return RPSShape(playerMove: self)
    }
    
    init(opponent: OpponentMove, desiredOutcome: RPSRoundResult) {
        self = PlayerMove.allCases.first { player in
            RPSRound(opponentMove: opponent, playerMove: player).result == desiredOutcome
        }!
    }
}

enum RPSRoundResult: Int {
    case victory = 6
    case draw = 3
    case loss = 0
    
    init?(code: String) {
        switch code {
        case "X":
            self = .loss
        case "Y":
            self = .draw
        case "Z":
            self = .victory
        default:
            return nil
        }
    }
}

struct RPSRound {
    let opponentMove: OpponentMove
    let playerMove: PlayerMove
    
    init(opponentMove: OpponentMove, playerMove: PlayerMove) {
        self.opponentMove = opponentMove
        self.playerMove = playerMove
    }
    
    var result: RPSRoundResult {
        if playerMove.shape > opponentMove.shape {
            return .victory
        } else if playerMove.shape < opponentMove.shape {
            return .loss
        }
        return .draw
    }
    
    var score: Int {
        return result.rawValue + playerMove.shape.rawValue
    }
}

// MARK: - Part 1
let rounds1 = readPlayerMoves(fromFile: "input")
let totalScore1 = rounds1.reduce(0) { $0 + $1.score }
print(totalScore1)

// MARK: - Part 2
let opponentMovesAndDesiredOutcomes = readOpponentMoveAndDesiredOutcome(fromFile: "input")
let rounds2 = opponentMovesAndDesiredOutcomes.map { (opponentMove, desiredOutcome) in
    let playerMove = PlayerMove(opponent: opponentMove, desiredOutcome: desiredOutcome)
    let round = RPSRound(opponentMove: opponentMove, playerMove: playerMove)
    return round
}
let totalScore2 = rounds2.reduce(0) { $0 + $1.score }
print(totalScore2)
