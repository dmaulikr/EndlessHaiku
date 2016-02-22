//
//  EndlessHaikuTests.swift
//  EndlessHaikuTests
//
//  Created by Thinh Luong on 1/19/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import XCTest
@testable import EndlessHaiku

class EndlessHaikuTests: XCTestCase {
  // MARK: Tests
  func testGetRandomHaiku() {
    let haiku = haikuManager.getRandomHaiku()
    
    XCTAssert(!haiku.author.isEmpty)
    XCTAssert(!haiku.lines.isEmpty)
    XCTAssert(!haiku.getHaikuLines().isEmpty)
    
  }
  
  func testHaikuGetHaikuLines() {
    let linesFormatted = testHaiku.getHaikuLines()
    let expectedLinesFormatted = "Line1\nLine2\nLine3"
    
    XCTAssert(linesFormatted == expectedLinesFormatted)
  }
  
  // MARK: Lifecycle
  override func setUp() {
    super.setUp()
    
    haikuManager = HaikuManager()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Properties
  var haikuManager: HaikuManager!
  let testHaiku = Haiku(author: "Author", lines: ["Line1", "Line2", "Line3"])
}
