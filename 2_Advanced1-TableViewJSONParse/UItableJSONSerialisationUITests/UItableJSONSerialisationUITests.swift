//
//  UItableJSONSerialisationUITests.swift
//  UItableJSONSerialisationUITests
//
//  Created by Ben Smith on 19/01/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import XCTest

class UItableJSONSerialisationUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTypingJaws() {
        
        let app = XCUIApplication()
        
        app.tables.buttons["Episode"].tap()
        
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.typeText("J")
        
        app.keys["a"].tap()
        searchSearchField.typeText("a")
        app.keys["w"].tap()
        searchSearchField.typeText("w")
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.tap()
        app.typeText("s")
        element.tap()
        app.typeText("\n")
        

    }
    
}
