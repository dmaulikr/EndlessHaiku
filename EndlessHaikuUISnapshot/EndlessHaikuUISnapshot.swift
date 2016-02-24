//
//  EndlessHaikuUISnapshot.swift
//  EndlessHaikuUISnapshot
//
//  Created by Thinh Luong on 2/23/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import XCTest

class EndlessHaikuUISnapshot: XCTestCase {
  
  // MARK: 
  func testSnapshotOne() {
    app.staticTexts["Swipe"].swipeLeft()
    snapshot("aFirst")
  }
  
  func testSnapshotTwo() {
    app.staticTexts["Swipe"].swipeLeft()
    
    menuButton.tap()
    snapshot("bSecond")
    
    settingsButton.tap()
    snapshot("cThird")
    
    app.tables["SettingsTable"].swipeUp()
    snapshot("dFourth")
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app.launch()
    
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  let app = XCUIApplication()
  
  var menuButton: XCUIElement {
    get {
      return app.buttons["MenuButton"]
    }
  }
  
  var settingsButton: XCUIElement {
    get {
      return app.buttons["SettingsButton"]
    }
  }
}


























