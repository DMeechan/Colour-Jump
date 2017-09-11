//
//  GameFunctions.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 10/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
  
  // MARK: Movement
  
  func moveVertically(up: Bool) {
    var movementIncrement = 0
    
    if up {
      movementIncrement = 3
    } else {
      movementIncrement = -3
    }
    
    let moveAction = SKAction.moveBy(x: 0, y: CGFloat(movementIncrement), duration: 0.01)
    let repeatAction = SKAction.repeatForever(moveAction)
    player?.run(repeatAction)
    
  }
  
  func moveToNextTrack() {
    player?.removeAllActions()
    movingToTrack = true
    
    guard let nextTrack = tracks?[currentTrack + 1].position else { return }
    
    if let player = self.player {
      let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y), duration: 0.2)
      let up = directionArray[currentTrack + 1]
      
      player.run(moveAction, completion: {
        self.movingToTrack = false
        
        if self.currentTrack != 8 {
          self.player?.physicsBody?.velocity = up ? CGVector(dx: 0, dy: self.velocityArray[self.currentTrack]) : CGVector(dx: 0, dy: -self.velocityArray[self.currentTrack])
        } else {
          self.player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
      })
      currentTrack += 1
      
      // TODO: Re-enable sound
      // self.run(moveSound)
    }
    
  }
  
  func movePlayerToStart() {
    if let player = self.player {
      player.removeFromParent()
      self.player = nil
      self.createPlayer()
      self.currentTrack = 0
      
    }
  }
  
  func nextLevel(playerPhysicsBody: SKPhysicsBody) {
    if let emitter = SKEmitterNode(fileNamed: "Fireworks.sks") {
      playerPhysicsBody.node?.addChild(emitter)
      
      self.run(SKAction.wait(forDuration: 0.5)) {
        emitter.removeFromParent()
        self.movePlayerToStart()
        
      }
    }
    
  }
  
  // MARK: Spawning
  
  func spawnEnemies() {
    for i in 1 ... 7 {
      guard let randomEnemyType = Enemies(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3)) else { return }
      if let newEnemy = createEnemy(type: randomEnemyType, forTrack: i) {
        self.addChild(newEnemy)
      }
    }
    
    // Go through each child node with the name ENEMY in self and check if it can be removed (it's outside the scene) -> optimise memory
    self.enumerateChildNodes(withName: "ENEMY") { (node: SKNode, nil) in
      if node.position.y < -150 || node.position.y > self.size.height + 150 {
        node.removeFromParent()
      }
    }
    
  }
}
