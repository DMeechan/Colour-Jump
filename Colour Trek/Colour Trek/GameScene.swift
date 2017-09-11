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
  
  var currentTrack = 0
  var movingToTrack = false
  
  let moveSound = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
  
  let trackVelocities = [180, 200, 250]
  var directionArray = [Bool]()
  var velocityArray = [Int]()
  
  let playerCategory: UInt32 = 0x1      // 1
  let enemyCategory: UInt32 = 0x10      // 2
  let targetCategory: UInt32 = 0x11     // 3
  

  
  // What to run when loads
  override func didMove(to view: SKView) {
    setupTracks()
    tracks?.first?.color = UIColor.green
    
    createPlayer()
    createTarget()
    
    self.physicsWorld.contactDelegate = self
    
    
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
  
  override func update(_ currentTime: TimeInterval) {
    if let player = self.player {
      if player.position.y > self.size.height || player.position.y < 0 {
        movePlayerToStart()
        
      }
      
    }
  }
  
  // What to run when 2 objects collide
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
      movePlayerToStart()
    
    } else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == targetCategory {
      nextLevel(playerPhysicsBody: playerBody)
      
    }
    
    
  }
  
}
