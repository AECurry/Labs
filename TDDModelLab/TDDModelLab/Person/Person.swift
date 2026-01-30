//
//  Person.swift
//  TDDModelLab
//
//  Created by AnnElaine on 1/23/26.
//

import Foundation

struct Person {
    let firstName: String
    let lastName : String
    let age: Int
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    func callAge() -> Int {
        age
    }
    
    func canDrive() -> Bool {
        if age > 16 {
            return true
        } else {
            return false
        }
    }
}
