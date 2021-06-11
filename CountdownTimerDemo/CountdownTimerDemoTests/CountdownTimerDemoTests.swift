//
//  CountdownTimerDemoTests.swift
//  CountdownTimerDemoTests
//
//  Created by Libor Kučera on 10.06.2021.
//

import XCTest
@testable import CountdownTimerDemo
@testable import CountdownTimer

class CountdownTimerDemoTests: XCTestCase {

    var manager: CountDownManager = CountDownManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager.cancel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let operations: [Operation] = [
            CountDownOperation(actionBlock: {
                print("operation 1")
            }),
            CountDownOperation(actionBlock: {
                print("operation 2")
            }),
            CountDownOperation(actionBlock: {
                print("operation 3")
            })
        ]
        self.manager.processAsync(operations) {
            print("Done")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
