//
//  BuyFlowTests.swift
//  FitForestTests
//
//  Created by Kyle Vigorito on 9/6/21.
//

import Foundation

import XCTest
@testable import FitForest

class BuyFlowTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasEnoughCurrency() throws {
        let points = 500
        let newStoreItem = StoreItem(name: "Test Item", description: "This is a test item.", classIdentifier: "Ball", price: 600) // Using valid class identifier, should decouple this.
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
