import Foundation

class Octopus {
    private(set) var y: Int
    private(set) var x: Int
    private(set) var energy: Int
    private(set) var flashed: Bool = false
    
    var shouldFlash: Bool {
        return energy > 9 && flashed == false
    }
    
    init(y: Int, x: Int, energy: Int) {
        self.y = y
        self.x = x
        self.energy = energy
    }
    
    func increaseEnergy() {
        energy += 1
    }
    
    func flash() {
        flashed = true
    }
    
    func resetEnergy() {
        energy = 0
    }
    
    func resetFlash() {
        flashed = false
    }
}
