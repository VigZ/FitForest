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
    
    var inAppBuyFlow: InAppCurrencyBuyFlow?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let inventoryManager = InventoryManager(items: [Item](), runyunStorage: [RunyunStorageObject]())
        inAppBuyFlow = InAppCurrencyBuyFlow(points: 500, inventory: inventoryManager)
    }

    override func tearDownWithError() throws {
        NotificationCenter.default.removeObserver(self)
    }

    func testHasEnoughCurrencyError() throws {
        let newStoreItem = StoreItem(name: "Test Item", description: "This is a test item.", classIdentifier: "Ball", price: 600) // Using valid class identifier, should decouple this.
        XCTAssertThrowsError(try inAppBuyFlow?.validatePurchase(newStoreItem)) { error in
            XCTAssertEqual(error as! BuyFlowErrors, BuyFlowErrors.notEnoughCurrency(currency: inAppBuyFlow!.points))
        }
    }
        
    func testHasEnoughInventorySpace() throws {
        
        let newStoreItem = StoreItem(name: "Test Ball", description: "This is a test item.", classIdentifier: "Ball", price: 500) // Using valid class identifier, should decouple this.
        
        // Testing against the name of store item and inventory item.
        
        for _ in 1...3 {
            let testItem = Ball(stackLimit: 3, name: "Test Ball", itemDescription: "This is a test ball.", itemState: .inInventory, itemType: .toy, weight: 1.0)
            inAppBuyFlow?.inventory.items.append(testItem)
        }
        
        XCTAssertThrowsError(try inAppBuyFlow?.validatePurchase(newStoreItem)) { error in
            XCTAssertEqual(error as! BuyFlowErrors, BuyFlowErrors.notEnoughInventorySpace)
        }
    }
    
    func testSuccessfulBuyCompletedNotification() {
        
        let newStoreItem = StoreItem(name: "Test Ball", description: "This is a test item.", classIdentifier: "Ball", price: 500)
        
        let points = 700
        
        let expected = XCTNSNotificationExpectation(name: Notification.Name.StoreEvents.itemPurchased, object: nil )
        
        // post notification
        inAppBuyFlow?.sendSuccessNotifications(newStoreItem, remainingPoints: points)
        
        // wait for response
        
        wait(for: [expected], timeout: 5)
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
