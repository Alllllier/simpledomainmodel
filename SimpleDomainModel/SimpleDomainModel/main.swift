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
  public static let availableCurrency = ["USD", "GBP", "EUR", "CAN"]

  public func convert(_ to: String) -> Money {
    if self.currency == to {
      return self
    }
    switch self.currency {
    case "USD":
      switch to {
      case "GBP":
        return Money(amount: Int(self.amount / 2), currency: to)
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 1.5), currency: to)
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 1.25), currency: to)
      default:
        return Money(amount: 0, currency: to)
      }
    case "GBP":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) * 2), currency: to)
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 3), currency: to)
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 5 / 2), currency: to)
      default:
        return Money(amount: 0, currency: to)
      }
    case "EUR":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) / 1.5), currency: to)
      case "GBP":
        return Money(amount: Int(self.amount / 3), currency: to)
      case "CAN":
        return Money(amount: Int(Double(self.amount) * 5 / 6), currency: to)
      default:
        return Money(amount: 0, currency: to)
      }
    case "CAN":
      switch to {
      case "USD":
        return Money(amount: Int(Double(self.amount) / 1.25), currency: to)
      case "GBP":
        return Money(amount: Int(Double(self.amount) * 2 / 5), currency: to)
      case "EUR":
        return Money(amount: Int(Double(self.amount) * 6 / 5), currency: to)
      default:
        return Money(amount: 0, currency: to)
      }
    default:
      return Money(amount: 0, currency: self.currency)
    }
  }
  
  public func add(_ to: Money) -> Money {
    let newAmount = self.convert(to.currency).amount + to.amount
    return Money(amount: newAmount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let newAmount = self.convert(from.currency).amount - from.amount
    return Money(amount: newAmount, currency: from.currency)
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
    case JobType.Hourly(let amount):
      return Int(amount * Double(hours))
    case JobType.Salary(let amount):
      return amount
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case JobType.Hourly(let amount):
      self.type = JobType.Hourly(amount + amt)
    case JobType.Salary(let amount):
      self.type = JobType.Salary(amount + Int(amt))
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
  
  open var fullname: String {
    get { return self.firstName + " " + self.lastName }
  }

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return self._job }
    set(value) {
      if self.age >= 16 {
        self._job = value
      } else {
        return
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return self._spouse }
    set(value) {
      if self.age >= 18 {
        self._spouse = value
      } else {
        return
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) " +
    "age:\(age) job:\(self._job?.title ?? "nil") spouse:\(self._spouse?.fullname ?? "nil")]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  fileprivate var canChild : Bool
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1._spouse = spouse2
    spouse2._spouse = spouse1
    self.members.append(spouse1)
    self.members.append(spouse2)
    canChild = spouse1.age > 21 || spouse2.age > 21
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if (canChild) {
      members.append(child)
      return true
    } else {
      return false
    }
  }
  
  open func householdIncome() -> Int {
    var total: Int = 0;
    for member in self.members {
      if let job = member.job {
        switch job.type {
        case Job.JobType.Salary(let amt):
          total += amt
        case Job.JobType.Hourly(let amt):
          total += Int(amt * 2000)
        }
      }
    }
    return total
  }
}





