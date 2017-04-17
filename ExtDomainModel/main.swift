//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

// MARK: Protocols

protocol Mathmatics {
    func add(_ to: Money) -> Money
    
    func subtract(_ from: Money) -> Money
}

// MARK: Extensions

extension Double {
    // USD, GBP, EUR, CAN
    var USD: Money { return Money(amount: Int(self), currency: "USD") }
    var GBP: Money { return Money(amount: Int(self), currency: "GBP") }
    var EUR: Money { return Money(amount: Int(self), currency: "EUR") }
    var CAN: Money { return Money(amount: Int(self), currency: "CAN") }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathmatics {
    public var amount : Int
    public var currency : String
    
    // Protocol var
    public var description: String {
        return "\(currency)\(Double(amount))"
    }
    
    //    1 USD = .5 GBP (2 USD = 1 GBP)
    //
    //    1 USD = 1.5 EUR (2 USD = 3 EUR)
    //
    //    1 USD = 1.25 CAN (4 USD = 5 CAN)
    public func convert(_ to: String) -> Money {
        var newAmount = toUSD(amount: self.amount * 100, currency: self.currency)
        newAmount = fromUSD(amount: newAmount, currency: to)
        return Money(amount: newAmount / 100, currency: to)
    }
    
    // Conversion rate to USD from GBP, EUR, CAN, or USD
    public func toUSD(amount: Int, currency: String) -> Int {
        if currency == "GBP"  {
            return amount * 2
        } else if currency == "EUR" {
            return amount * 2 / 3
        } else if currency == "CAN" {
            return amount * 4 / 5
        } else if currency == "USD" {
            return amount
        }
        return -1
    }
    
    // Assumes passing in USD
    public func fromUSD(amount: Int, currency: String) -> Int {
        if currency == "GBP"  {
            return amount / 2
        } else if currency == "EUR" {
            return amount * 3 / 2
        } else if currency == "CAN" {
            return amount * 5 / 4
        } else if currency == "USD" {
            return amount
        }
        return -1
    }
    
    public func add(_ to: Money) -> Money {
        let myAmount = self.convert(to.currency).amount
        return Money(amount: myAmount + to.amount, currency: to.currency)
    }
    public func subtract(_ from: Money) -> Money {
        let myAmount = self.convert(from.currency).amount
        return Money(amount: myAmount - from.amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        let jobType = self.type
        switch jobType {
        case .Hourly(let amount):
            let calc = Double(hours) * amount
            return Int(calc)
        case .Salary(let amount):
            return amount
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let amount):
            self.type = .Hourly(amount + amt)
        case .Salary(let amount):
            let raiseAmt = Double(amount) + amt
            self.type = .Salary(Int(raiseAmt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {return self._job }
        set(value) {
            if self.age > 15 {
                self._job = Job(title: (value?.title)!, type: (value?.type)!)
            } else {
                self._job = nil
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {return self._spouse }
        set(value) {
            if self.age > 17 {
                self._spouse = Person(firstName: (value?.firstName)!,
                                      lastName: (value?.lastName)!,
                                      age: (value?.age)!)
            } else {
                self._spouse = nil
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    // [Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) " +
        "age:\(self.age) job:\(self._job) spouse:\(self._spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for Person in self.members {
            if (Person.age >= 21) {
                self.members.append(child)
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var totalIncome = 0
        for Person in self.members {
            // 2000 hours worked in a year
            if Person._job != nil {
                totalIncome += (Person._job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
}





