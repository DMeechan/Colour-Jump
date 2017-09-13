//
//  GameOverScene.swift
//  ACGame
//
//  Created by Brian Advent on 16.06.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import SpriteKit
import Firebase
import GoogleMobileAds

class GameOverScene: SKScene, GADInterstitialDelegate {
  
  var lastScoreLabel:SKLabelNode?
  var bestScoreLabel:SKLabelNode?
  
  var playButton:SKSpriteNode?
  
  var backgroundMusic: SKAudioNode!
  
  override func didMove(to view: SKView) {
    lastScoreLabel = self.childNode(withName: "lastScoreLabel") as? SKLabelNode
    bestScoreLabel = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
    
    lastScoreLabel?.text = "\(GameHandler.shared.score)"
    bestScoreLabel?.text = "\(GameHandler.shared.highScore)"
    
    playButton = self.childNode(withName: "startButton") as? SKSpriteNode
    
    if let musicURL = Bundle.main.url(forResource: "Sounds/MenuHighscoreMusic", withExtension: "mp3") {
      backgroundMusic = SKAudioNode(url: musicURL)
      addChild(backgroundMusic)
    }
    
    if let view = self.view?.window?.rootViewController {
      GameHandler.shared.showInterstitialAd(viewController: view, delgate: self)
    }
    
    GameHandler.shared.logGameOver()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let pos = touch.location(in: self)
      let node = self.atPoint(pos)
      
      // Check if play button clicked
      if node == playButton {
        GameHandler.shared.loadIntertitialAd()
        
        let transition = SKTransition.fade(withDuration: 1)
        if let gameScene = SKScene(fileNamed: "GameScene") {
          gameScene.scaleMode = .aspectFit
          self.view?.presentScene(gameScene, transition: transition)
          
        }
      }
    }
  }
  
}
