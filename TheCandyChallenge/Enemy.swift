import Foundation

enum Enemies: Int {
    case normalCandy = 1
    case chocklade = 2
    case soda = 3
}

class Enemy: Printable {
    let type: Int
    let date: NSDate
    var amount: Int {
        didSet {
            if amount < 0 {
                amount = 0
            }
        }
    }
    
    var price: Int {
        return amount * self.getPriceForUnit()
    }
    
    var description: String {
        return "\(type), date: \(date), amount: \(amount)"
    }
    
    init(type: Int, date: NSDate, amount: Int) {
        self.type = type
        self.date = date
        self.amount = amount
    }
    
    func fromTypeToString() -> String {
        switch type {
        case Enemies.chocklade.rawValue:
            return "Chockolade"
        case Enemies.soda.rawValue:
            return "Soda"
        default:
            println("enemy not mapped out")
            return "None"
        }
    }
    
    func getPriceForUnit() -> Int {
        switch type {
        case Enemies.chocklade.rawValue:
            return 30
        case Enemies.soda.rawValue:
            return 18
        default:
            println("enemy not mapped out")
            return 0
        }
    }
}