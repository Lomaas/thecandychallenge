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
    
    var description: String {
        return "\(type), date: \(date), amount: \(amount)"
    }
    
    init(type: Int, date: NSDate, amount: Int) {
        self.type = type
        self.date = date
        self.amount = amount
    }
    
    
}