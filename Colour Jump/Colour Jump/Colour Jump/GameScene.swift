//
//  GameScene.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 31/08/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var tracks: [SKSpriteNode]? = [SKSpriteNode]()
  var player: SKSpriteNode?
  var target: SKSpriteNode?
  
  var timeLabel: SKLabelNode?
  var scoreLabel: SKLabelNode?
  var currentScore: Int = 0 {
    didSet {
      self.scoreLabel?.text = "SCORE: \(self.currentScore)"
    }
  }
  var remainingTime: TimeInterval = 60 {
    didSet {
      self.timeLabel?.text = "TIME: \(Int(self.remainingTime))"
    }
  }
  
  var currentTrack = 0
  var movingToTrack = false
  
  let moveSound = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
  let failSound = SKAction.playSoundFileNamed("Sounds/fail.wav", waitForCompletion: false)
  let levelUpSound = SKAction.playSoundFileNamed("Sounds/levelUp.wav", waitForCompletion: false)
  let powerUpSound = SKAction.playSoundFileNamed("Sounds/powerUp.wav", waitForCompletion: false)
  let levelCompletedSound = SKAction.playSoundFileNamed("Sounds/levelCompleted.wav", waitForCompletion: false)
  
  var backgroundNoise: SKAudioNode!
  
  let trackVelocities = [180, 200, 250]
  var directionArray = [Bool]()
  var velocityArray = [Int]()
  
  let playerCategory: UInt32 = 0x1      // 1
  let enemyCategory: UInt32 = 0x10      // 2
  let targetCategory: UInt32 = 0x11     // 3
  let powerUpCategory: UInt32 = 0x100   // 4
  
  // MARK: LAUNCH
  func launchGameTimer() {
    let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run ({
      self.remainingTime -= 1
      
    }), SKAction.wait(forDuration: 1)]))
    
    timeLabel?.run(timeAction)
  }
  
  func createHUD() {
    timeLabel = self.childNode(withName: "time") as? SKLabelNode
    scoreLabel = self.childNode(withName: "score") as? SKLabelNode
    
    remainingTime = 60
    currentScore = 0
    
  }
  
  // What to run when loads
  override func didMove(to view: SKView) {
    setupTracks()
    tracks?.first?.color = UIColor.green
    
    createHUD()
    launchGameTimer()
    createPlayer()
    createTarget()
    
    self.physicsWorld.contactDelegate = self
    
    if let musicURL = Bundle.main.url(forResource: "Sounds/background", withExtension: "wav") {
      backgroundNoise = SKAudioNode(url: musicURL)
      addChild(backgroundNoise)
      
    }
    
    
    if let numTracks = tracks?.count {
      for _ in 0 ... numTracks {
        let randomVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        velocityArray.append(trackVelocities[randomVelocity])
        directionArray.append(GKRandomSource.sharedRandom().nextBool())
      }
    }
    
    // Loop through forever, spawning enemies every 2 seconds
    self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
        self.spawnEnemies()
      }, SKAction.wait(forDuration: 2)])))
    
  }
  

  // MARK: BUTTON CONTROLS
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.previousLocation(in: self)
      let node = self.nodes(at: location).first
      
      if node?.name == "right" || node?.name == "rightImage" {
        moveToNextTrack()
        
      } else if node?.name == "up" || node?.name == "upImage" {
        moveVertically(up: true)
        
      } else if node?.name == "down" || node?.name == "downImage" {
        moveVertically(up: false)
        
      }
      
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !movingToTrack {
      player?.removeAllActions()
    }
    
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    player?.removeAllActions()
    
  }
  
  // MARK: RUN CONTINUOUSLY
  override func update(_ currentTime: TimeInterval) {
    // Reset player if moves off-screen
    if let player = self.player {
      if player.position.y > self.size.height || player.position.y < 0 {
        movePlayerToStart()
        
      }
    }
    
    // Check if running out of time
    if remainingTime <= 5 {
      timeLabel?.fontColor = UIColor.red
      
      if remainingTime == 0 {
        gameOver()
      }
      
    }
    
  }
  
  // MARK: COLLISIONS
  func didBegin(_ contact: SKPhysicsContact) {
    var playerBody: SKPhysicsBody
    var otherBody: SKPhysicsBody
    
    // If true, bodyA = player; otherwise bodyB = player :D
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      playerBody = contact.bodyA
      otherBody = contact.bodyB
      
    } else {
      otherBody = contact.bodyA
      playerBody = contact.bodyB

    }
    
    if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
      // Player hits enemy
      self.run(failSound)
      movePlayerToStart()
    
    } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
      nextLevel(playerPhysicsBody: playerBody)
      
    } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == powerUpCategory {
      self.run(powerUpSound)
      otherBody.node?.removeFromParent()
      remainingTime += 5
      
    }
    
    
  }
  
}
