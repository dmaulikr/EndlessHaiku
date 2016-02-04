//
//  Haiku.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

struct Haiku {
  
  // MARK: Functions
  func getHaikuLines() -> String {
    let newline = "\n"
    let formattedLines = lines[0] + newline + lines[1] + newline + lines[2]
    
    return formattedLines
  }
  
  // MARK: Properties
  let author: String
  let lines: [String]
}
