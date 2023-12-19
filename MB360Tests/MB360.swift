//
//  MyBenefitsTests.swift
//  MyBenefitsTests
//
//  Created by Semantic on 11/04/18.
//  Copyright © 2018 Semantic. All rights reserved.
//

import XCTest
@testable import MyBenefits

var mybenefitsUnderTest : LoginViewController
class MyBenefitsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        mybenefitsUnderTest = LoginViewController()
        mybenefitsUnderTest.sendOTP()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mybenefitsUnderTest=nil
        super.tearDown()
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
    
}
