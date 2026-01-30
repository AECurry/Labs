//
//  TDDModelLabTests.swift
//  TDDModelLabTests
//
//  Created by AnnElaine on 1/23/26.
//

import XCTest
@testable import TDDModelLab

final class TDDModelLabTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class TestPerson: XCTestCase {
    
    func testFullName() {
        
        let person = Person(firstName: "John", lastName: "Doe", age: 26)
        
        XCTAssertEqual(person.fullName, "John Doe")
    }
    
    
    func testAge() {
        
        let person = Person(firstName: "John", lastName: "Doe", age: 26)
        
        var personHasAge = false
        
        if person.callAge() > 0 {
             personHasAge = true
        }
        
        XCTAssert(personHasAge)
    }
    
    func testCanDrive() {
        let person = Person(firstName: "John", lastName: "Doe", age: 26)
        
        var canDrive = false
        if person.age > 16 {
            canDrive = true
        }
            XCTAssertEqual(canDrive, person.canDrive())
        
    }
}
