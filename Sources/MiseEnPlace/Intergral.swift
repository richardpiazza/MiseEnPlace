import Foundation

/// Enumeration of commonly used intergrals in cooking.
public enum Integral: Int, CaseIterable, CustomStringConvertible {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case eleven = 11
    case twelve = 12
    case thirteen = 13
    case fourteen = 14
    case fifteen = 15
    case twenty = 20
    case twentyFive = 25
    case thirty = 30
    case thirtyFive = 35
    case fourty = 40
    case fourtyFive = 45
    case fifty = 50
    case sixty = 60
    case seventy = 70
    case eighty = 80
    case ninety = 90
    case oneHundred = 100
    case oneTwentyFive = 125
    case oneFifty = 150
    case oneSeventyFive = 175
    case twoHundred = 200
    case twoFifty = 250
    case threeHundred = 300
    case fourHundred = 400
    case fiveHundred = 500
    case sixHundred = 600
    case sevenHundred = 700
    case sevenFifty = 750
    case eightHundred = 800
    case nineHundred = 900
    
    public static let singleDigits: [Integral] = [.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine]
    
    public var description: String {
        return "\(self.rawValue)"
    }
}
