//
//  HaikuManager.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/2/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import Foundation

class HaikuManager {
  // MARK: Functions
  /**
  Get a random haiku
  
  - returns: haiku
  */
  func getRandomHaiku() -> Haiku {
    var randomIndex: Int
    
    repeat {
      randomIndex = Int(arc4random_uniform(UInt32(haikus.count)))
    } while randomIndex == currentIndex
    
    return haikus[randomIndex]
  }
  
  /**
   Parse CSV file and generate an array of haiku objects
   
   - parameter contentsOfURL: location of csv file
   - parameter encoding:      string encoding
   
   - returns: array of haiku
   */
  private func parseCSV(contentsOfURL: NSURL, encoding: NSStringEncoding) -> [Haiku] {
    let delimiter = "#"
    
    var haikus = [Haiku]()
    
    if let content = try? String(contentsOfURL: contentsOfURL, encoding: encoding) {
      
      let lines: [String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
      
      for line in lines {
        var values: [String] = []
        
        if line != "" {
          
          // For a line with double quotes
          // we use NSScanner to perform the parsing
          if line.rangeOfString("\"") != nil {
            var textToScan: String = line
            var value: NSString?
            var textScanner: NSScanner = NSScanner(string: textToScan)
            
            while textScanner.string != "" {
              if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                textScanner.scanLocation += 1
                textScanner.scanUpToString("\"", intoString: &value)
                textScanner.scanLocation += 1
              } else {
                textScanner.scanUpToString(delimiter, intoString: &value)
              }
              
              // Store the value into the values array
              values.append(value as! String)
              
              //
              if textScanner.scanLocation < textScanner.string.characters.count {
                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
              } else {
                textToScan = ""
              }
              
              textScanner = NSScanner(string: textToScan)
            }
            
            // For a line without double quotes, we can simply separate the string
            // by using the delimiter (e.g. comma)
          } else {
            values = line.componentsSeparatedByString(delimiter)
          }
          
          let author = values[0]
          let slice = values[1..<values.count]
          var lines = [String]()
          lines += slice
          
          let haiku = Haiku(author: author, lines: lines)
          
          haikus.append(haiku)
        }
      }
    }
    
    return haikus
  }
  
  
  // MARK: Lifecycle
  init() {
    if let url = NSBundle.mainBundle().URLForResource("Haiku", withExtension: "csv") {
      haikus = parseCSV(url, encoding: NSUTF8StringEncoding)
    }
  }
  
  // MARK: Properties
  private var haikus: [Haiku]!
  private var currentIndex = 0
}

































