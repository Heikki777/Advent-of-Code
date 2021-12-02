import Foundation

class Submarine {
    
    private var position: (x: Int, depth: Int, aim: Int) = (0, 0, 0)
    private var commands: [Command] = []
    
    func readCommands(fromFile file: String) {
        
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                self.commands = try String(contentsOfFile: filepath)
                    .split(separator: "\n")
                    .map { String($0) }
                    .compactMap { Command(rawValue: $0)}
                
            } catch {
                print("Contents could not be loaded")
            }
        } else {
            print("\(file).txt not found")
        }
    }
    
    func executeCommands(withAim aim: Bool) {
        
        guard commands.isEmpty == false else {
            print("There are no commands to execute")
            return
        }
        
        commands.forEach { command in
            switch command {
            case .down(let unit):
                if aim {
                    position.aim += unit
                } else {
                    position.depth += unit
                }
            case .up(let unit):
                if aim {
                    position.aim -= unit
                } else {
                    position.depth -= unit
                }
            case .forward(let unit):
                if aim {
                    position.x += unit
                    position.depth += position.aim * unit
                } else {
                    position.x += unit
                }
            }
        }
    }
    
    func resetPosition() {
        self.position = (0, 0, 0)
    }
    
    func printPosition() {
        print(position, "->", position.depth * position.x)
    }
    
    enum Command: RawRepresentable {
        
        case forward(Int)
        case up(Int)
        case down(Int)
        
        var rawValue: String {
            switch self {
            case .down(let unit):
                return "down \(unit)"
            case .up(let unit):
                return "up \(unit)"
            case .forward(let unit):
                return "forward \(unit)"
            }
        }
        
        init?(rawValue: String) {
            let trimmed = rawValue.trimmingCharacters(in: CharacterSet([" "]))
            let splitted = trimmed.split(separator: " ")
            
            guard splitted.count > 1 else {
                return nil
            }
    
            guard let unit = Int(splitted[1]) else {
                return nil
            }
            
            let direction = String(splitted[0])
            
            if direction == "forward" {
                self = .forward(unit)
            } else if direction == "up" {
                self = .up(unit)
            } else if direction == "down" {
                self = .down(unit)
            } else {
                return nil
            }
        }
    }
}

// First part
let submarine = Submarine()
submarine.readCommands(fromFile: "input")
submarine.executeCommands(withAim: false)
submarine.printPosition()

// Second part
let submarine2 = Submarine()
submarine2.readCommands(fromFile: "input")
submarine2.executeCommands(withAim: true)
submarine2.printPosition()




