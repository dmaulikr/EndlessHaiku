//
//  EndlessHaikuUITests.swift
//  EndlessHaikuUITests
//
//  Created by Thinh Luong on 1/19/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import XCTest

class EndlessHaikuUITests: XCTestCase {
  
  // MARK: Tests
  func testSwipeTextExists() {
    XCTAssert(app.staticTexts["Swipe"].exists)
  }
  
  func testMenuButton() {
    menuButton.tap()
    menuButton.tap()
  }
  
  func testFacebookButton() {
    menuButton.tap()
    facebookButton.tap()
    app.buttons["Done"].tap()
  }
  
  func testTwitterButton() {
    menuButton.tap()
    twitterButton.tap()
    app.buttons["Done"].tap()
  }
  
  func testRateButton() {
    menuButton.tap()
    rateButton.tap()
    app.buttons["Done"].tap()
  }
  
  func testCreditsButton() {
    menuButton.tap()
    creditsButton.tap()
    creditsButton.tap()
  }
  
  func testSoundButton() {
    menuButton.tap()
    soundButton.tap()
    soundButton.tap()
  }
  
  func testSettingsButton() {
    goToSettingsVC()
    
    let backButton = app.navigationBars["Settings"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0)
    backButton.tap()
    
  }
  
  func testVoicePicker() {
    goToSettingsVC()
    
    let settingstableTable = app.tables["SettingsTable"]
    settingstableTable.pickerWheels["English (United States)"].tap()
    
  }
  
  func testRateSlider() {
    goToSettingsVC()
    
    let settingstableTable = app.tables["SettingsTable"]
    let slider = settingstableTable.otherElements["RateSlider"]
    slider.tap()
  }
  
  func testPitchSlider() {
    goToSettingsVC()
    
    let settingstableTable = app.tables["SettingsTable"]
    let slider = settingstableTable.otherElements["PitchSlider"]
    slider.tap()
  }
  
  func testVolumeSlider() {
    goToSettingsVC()
    
    let settingstableTable = app.tables["SettingsTable"]
    let slider = settingstableTable.otherElements["VolumeSlider"]
    slider.tap()
  }
  
  func testSettingsSaveButton() {
    goToSettingsVC()
    
    let saveButton = app.navigationBars["Settings"].childrenMatchingType(.Button).matchingIdentifier("Save").elementBoundByIndex(0)
    saveButton.tap()
  }
  
  // MARK: Helpers
  func goToSettingsVC() {
    menuButton.tap()
    settingsButton.tap()
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
  
  var facebookButton: XCUIElement {
    get {
      return app.buttons["FacebookButton"]
    }
  }
  
  var twitterButton: XCUIElement {
    get {
      return app.buttons["TwitterButton"]
    }
  }
  
  var rateButton: XCUIElement {
    get {
      return app.buttons["RateButton"]
    }
  }
  
  var creditsButton: XCUIElement {
    get {
      return app.buttons["CreditsButton"]
    }
  }
  
  var soundButton: XCUIElement {
    get {
      return app.buttons["SoundButton"]
    }
  }
  
  var settingsButton: XCUIElement {
    get {
      return app.buttons["SettingsButton"]
    }
  }
}
