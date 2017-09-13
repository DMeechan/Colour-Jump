//
//  GameHandler.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 11/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import UIKit

class GameHandler {
  
  let pink: UIColor = UIColor(red:0.94, green:0.38, blue:0.57, alpha:1.0) // #f06292
  let indigo: UIColor = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0) // #448aff
  let green: UIColor = UIColor(red:0.00, green:0.90, blue:0.46, alpha:1.0) // #00e676
  
  var score: Int
  var highScore: Int
  
  class var shared: GameHandler {
    struct Singleton {
      static let instance = GameHandler()
    }
    
    return Singleton.instance
    
  }
  
  init() {
    score = 0
    highScore = 0
    
    let userDefaults = UserDefaults.standard
    highScore = userDefaults.integer(forKey: "highScore")
    
  }
  
  func saveGameStats() {
    highScore = max(score, highScore)
    
    let userDefaults = UserDefaults.standard
    userDefaults.set(highScore, forKey: "highScore")
    userDefaults.synchronize()
    
  }
  
}
