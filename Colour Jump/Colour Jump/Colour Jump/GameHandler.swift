//
//  GameHandler.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 11/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import Foundation

class GameHandler {
  
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
