import UIKit

class Submarine {
    
    private let inputFile: String = "input"
    
    func calculatePowerConsumption() -> Int? {
        guard
            let gamma = submarine.calculateGammaRate(),
            let epsilon = submarine.calculateEpsilonRate()
        else { return nil }
        
        return gamma.decimal * epsilon.decimal
    }
    
    func calculateLifeSupportRating() -> Int? {
        guard
            let oxygenGeneratorRating = submarine.calculateOxygenGeneratorRating(),
            let co2ScrubberRating = submarine.calculateC02ScrubberRating()
        else { return nil }
        
        return oxygenGeneratorRating.decimal * co2ScrubberRating.decimal
    }
    
    private func readDiagnosticsReport(fromFile file: String) -> [String] {
        
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                return try String(contentsOfFile: filepath)
                    .split(separator: "\n")
                    .map { String($0) }
                
            } catch {
                print("Contents could not be loaded")
            }
        } else {
            print("\(file).txt not found")
        }
        return []
    }
    
    private func calculateGammaRate() -> (binary: String, decimal: Int)? {
        let report = readDiagnosticsReport(fromFile: inputFile)

        guard let binaryLength = report.first?.count else { return nil }
                        
        var binaryResult = ""
        for index in 0..<binaryLength {
            var ones: Int = 0
            for binary in report {
                guard index < binary.count else { continue }
            
                let bit = binary[binary.index(binary.startIndex, offsetBy: index)]
                if bit == "1" {
                    ones += 1
                }
            }
            binaryResult += (ones >= report.count / 2) ? "1" : "0"
        }
        
        if let decimal = binaryResult.binaryToInt {
            return (binaryResult, decimal)
        }
        return nil
    }
    
    private func calculateEpsilonRate() -> (binary: String, decimal: Int)? {
        if let gammaRate = calculateGammaRate() {
            let epsilonBinary = String(gammaRate.binary.map { $0 == "1" ? "0" : "1" })
            if let epsilonDecimal = epsilonBinary.binaryToInt {
                return (epsilonBinary, epsilonDecimal)
            }
        }
        return nil
    }
    
    private func calculateOxygenGeneratorRating() -> (binary: String, decimal: Int)? {
        let report = readDiagnosticsReport(fromFile: inputFile)
        guard let binaryLength = report.first?.count else { return nil }

        var binaries = report
        
        for index in 0..<binaryLength {
            var ones = 0
            for binary in binaries {
                guard let bit = Int(String(binary[binary.index(binary.startIndex, offsetBy: index)])) else { continue }
                ones += bit
            }
            
            let mostCommonBit = (ones >= binaries.count - ones) ? "1" : "0"
            binaries = binaries.filter { binary in
                String(binary[binary.index(binary.startIndex, offsetBy: index)]) == mostCommonBit
            }
        }
        
        if let oxygenGeneratorRatingBinary = binaries.first,
            let oxygenGeneratorRatingDecimal = oxygenGeneratorRatingBinary.binaryToInt {
            return (oxygenGeneratorRatingBinary, oxygenGeneratorRatingDecimal)
        }
        
        return nil
    }
    
    func calculateC02ScrubberRating() -> (binary: String, decimal: Int)? {
        let report = readDiagnosticsReport(fromFile: inputFile)
        guard let binaryLength = report.first?.count else { return nil }

        var binaries = report
        
        for index in 0..<binaryLength {
            guard binaries.count > 1 else { break }
            var ones = 0
            for binary in binaries {
                guard let bit = Int(String(binary[binary.index(binary.startIndex, offsetBy: index)])) else { continue }
                ones += bit
            }
            
            let leastCommonBit = (ones < binaries.count - ones) ? "1" : "0"
            binaries = binaries.filter { binary in
                String(binary[binary.index(binary.startIndex, offsetBy: index)]) == leastCommonBit
            }
        }
        
        if let oxygenGeneratorRatingBinary = binaries.first,
            let oxygenGeneratorRatingDecimal = oxygenGeneratorRatingBinary.binaryToInt {
            return (oxygenGeneratorRatingBinary, oxygenGeneratorRatingDecimal)
        }
        
        return nil
    }
}

extension Int {
    var binaryString: String {
        return String(self, radix: 2)
    }
}

extension String {
    var binaryToInt: Int? {
        return Int(self, radix: 2)
    }
}

let submarine = Submarine()

// PART 1
submarine.calculatePowerConsumption()

// PART 2
submarine.calculateLifeSupportRating()
