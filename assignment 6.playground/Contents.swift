import UIKit

// Zero function using Numeric protocol
func zero<T: Numeric>(for type: T.Type) -> T {
    return T.zero
}

// Account Protocol with a generic CurrencyType
protocol Account: AnyObject {
    associatedtype CurrencyType: Numeric
    
    var _balance: CurrencyType { get set }
    var accountHolder: Person { get set }
    
    func deposit(_ amount: CurrencyType)
    func withdraw(_ amount: CurrencyType)
    func balance() -> CurrencyType
}
extension Account {
    func deposit(_ amount: CurrencyType) {
        _balance += amount
    }
    func withdraw(_ amount: CurrencyType) {
        _balance -= amount
    }
    func balance() -> CurrencyType {
        return _balance
    }
}

class Checking<T: Numeric>: Account {
    typealias CurrencyType = T
    var _balance: T = zero(for: T.self)
    unowned var accountHolder: Person
    
    init(_ holder: Person) {
        self.accountHolder = holder
    }
}
class Savings<T: Numeric>: Account {
    typealias CurrencyType = T
    var _balance: T = zero(for: T.self)
    unowned var accountHolder: Person
    
    init(_ holder: Person) {
        accountHolder = holder
    }
}


struct Possession {
    var cost: Double
    var name: String
}


class Person {
    var name: String
    var possessions: [Possession] = []
    
    private var _checking: Checking<Double>?
    private var _savings: Savings<Double>?
    
    var checking: Checking<Double> {
        return _checking!
    }
    
    var savings: Savings<Double> {
        return _savings!
    }
    
    init(_ Name: String) {
        self.name = Name
        self._checking = Checking<Double>(self)
        self._savings = Savings<Double>(self)
    }
}


let john = Person("John Doe")

// Check initial balances (should be 0)
print("Initial Checking Balance:", john.checking.balance()) // Expected: 0.0
print("Initial Savings Balance:", john.savings.balance()) // Expected: 0.0

// Deposit money into accounts
john.checking.deposit(1000)
john.savings.deposit(5000)

print("After Deposit - Checking Balance:", john.checking.balance()) // Expected: 1000.0
print("After Deposit - Savings Balance:", john.savings.balance()) // Expected: 5000.0

// Withdraw money from accounts
john.checking.withdraw(300)
john.savings.withdraw(1200)

print("After Withdraw - Checking Balance:", john.checking.balance()) // Expected: 700.0
print("After Withdraw - Savings Balance:", john.savings.balance()) // Expected: 3800.0

// Withdraw more than available balance (should allow negative balance for now)
john.checking.withdraw(1000)
print("Overdrawn Checking Balance:", john.checking.balance()) // Expected: -300.0

// Withdraw exactly the remaining balance
john.savings.withdraw(3800)
print("After Full Withdrawal - Savings Balance:", john.savings.balance()) // Expected: 0.0

// Add possessions to John
john.possessions.append(Possession(cost: 200, name: "Laptop"))
john.possessions.append(Possession(cost: 50, name: "Headphones"))

print("John's Possessions:")
for item in john.possessions {
    print("- \(item.name): $\(item.cost)")
}
// Expected:
// - Laptop: $200.0
// - Headphones: $50.0

// Create another person
let jane = Person("Jane Smith")
jane.checking.deposit(2500)
jane.savings.deposit(8000)

print("Jane's Checking Balance:", jane.checking.balance()) // Expected: 2500.0
print("Jane's Savings Balance:", jane.savings.balance()) // Expected: 8000.0
