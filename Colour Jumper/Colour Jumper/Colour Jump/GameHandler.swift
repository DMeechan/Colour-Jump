//
//  GameHandler.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 11/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class GameHandler {
  
  let pink: UIColor = UIColor(red:0.94, green:0.38, blue:0.57, alpha:1.0) // #f06292
  let indigo: UIColor = UIColor(red:0.27, green:0.54, blue:1.00, alpha:1.0) // #448aff
  let green: UIColor = UIColor(red:0.00, green:0.90, blue:0.46, alpha:1.0) // #00e676
  
  var interstitialAd: GADInterstitial!
  
  var showAd: Bool = false
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
    
    loadIntertitialAd()
    
  }
  
  func loadIntertitialAd() {
    // Only load an ad if it's gonna be shown next round (because it inverts the showAd value)
    if showAd == false {
      interstitialAd = createAndLoadInterstitial()
      
    }
  }
  
  func createAndLoadInterstitial() -> GADInterstitial? {
    let adUnitID = "ca-app-pub-4605466962808569/1752154621"
    // let adUnitID = "ca-app-pub-3940256099942544/1033173712" // Sample ad
    
    let interstitial = GADInterstitial(adUnitID: adUnitID)
    interstitial.load(GADRequest())
    
    return interstitial
    
  }
  
  func showInterstitialAd(viewController: UIViewController, delgate: GADInterstitialDelegate) {
    // So only show an ad every other game
    showAd = !showAd
    
    if showAd {
      interstitialAd.delegate = delgate
      
      if interstitialAd.isReady {
        interstitialAd.present(fromRootViewController: viewController)
        
      } else {
        showAd = false
        print("Ad wasn't ready")
        
      }
      
    }
    
    
  }
  
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    interstitialAd = createAndLoadInterstitial()
  }
  
  func saveGameStats() {
    highScore = max(score, highScore)
    
    let userDefaults = UserDefaults.standard
    userDefaults.set(highScore, forKey: "highScore")
    userDefaults.synchronize()
    
  }
  
  func logGameOver() {
    Analytics.logEvent("gameOver", parameters: [
      "score": score as NSObject,
      "highScore": highScore as NSObject
      
      ])
  }
  
  func logGameStart() {
    Analytics.logEvent("gameStart", parameters: [
      "highScore": highScore as NSObject
      
      ])
  }
  
}
