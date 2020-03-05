//
//  LightSpeedAssignmentTests.swift
//  LightSpeedAssignmentTests
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import XCTest
@testable import LightSpeedAssignment

class LightSpeedAssignmentTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoginAPIMapping() {
        let apiURL = "https://www.swapi.co/api/people"
        let asyncExpectation = expectation(description: "Async block executed")
        
        let getCharactersOp = MockGetCharactersOperation(url: apiURL){ (characterDetails, error) in
            //            DispatchQueue.main.async {
            XCTAssert(characterDetails?.count != nil)
            XCTAssert(characterDetails?.count == 87)
            XCTAssert(characterDetails?.next == "https://swapi.co/api/people/?page=2")
            //and so on we can test the response and other API similarly
            asyncExpectation.fulfill()
            //            }
        }
        let operationQueue = OperationQueue()
        operationQueue.addOperation(getCharactersOp)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
