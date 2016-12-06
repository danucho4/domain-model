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

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    let currentCurrency : String = self.currency
    var currentAmount : Int = self.amount
    
    if(currentCurrency != to) {
        if (currentCurrency != "USD") {
            if (currentCurrency == "GBP") {
                currentAmount = currentAmount * 2
            } else if (currentCurrency == "EUR") {
                currentAmount = currentAmount * 2 / 3
            } else {
                currentAmount = currentAmount * 4 / 5
            }
        }
        
        if (to != "USD") {
            if (to == "GBP") {
                currentAmount = currentAmount / 2
            } else if (to == "EUR") {
                currentAmount = currentAmount * 3 / 2
            } else {
                currentAmount = currentAmount * 5 / 4
            }
        }
    }
    return Money(amount: currentAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    var selfMoney = Money(amount: self.amount, currency: self.currency)
    if (selfMoney.currency != to.currency) {
        selfMoney = self.convert(to.currency)
    }
    selfMoney.amount += to.amount
    return selfMoney
  }
  public func subtract(_ from: Money) -> Money {
    var selfMoney = Money(amount: self.amount, currency: self.currency)
    if (selfMoney.currency != from.currency) {
        selfMoney = self.convert(from.currency)
    }
    var resultMoney = Money(amount: from.amount, currency: from.currency)
    resultMoney.amount -= selfMoney.amount
    return resultMoney
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
    switch self.type {
    case .Hourly(let hourly):
        return Int(hourly * Double(hours))
    case .Salary(let annual):
        return annual
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourly):
        self.type = JobType.Hourly(hourly + amt)
    case .Salary(let annual):
        self.type = JobType.Salary(annual + Int(amt))
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
    get {
        return _job
    }
    set(value) {
        if (self.age > 16) {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if (self.age >= 18) {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.age >= 21 || spouse2.age >= 21) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var total = 0
    for member in members {
        if (member.job != nil) {
            total += member.job!.calculateIncome(2000)
        }
    }
    return total
  }
}





