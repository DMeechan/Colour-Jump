//
//  GameElements.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 10/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Enemies: Int {
  case small
  case medium
  case large
}

extension GameScene {
 
  func setupTracks() {
    var i = 0
    while i < 9 {
      
      if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
        tracks?.append(track)
      }
      i += 1
    }
    
    if let numTracks = tracks?.count {
      for _ in 0 ... numTracks {
        let randomVelocity = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        velocityArray.append(trackVelocities[randomVelocity])
        directionArray.append(GKRandomSource.sharedRandom().nextBool())
      }
      
      velocityArray[0] = 0
      velocityArray[numTracks - 1] = 0
      
    }
    
  }
  
  func createTarget() {
    target = self.childNode(withName: "target") as? SKSpriteNode
    target?.physicsBody = SKPhysicsBody(circleOfRadius: target!.size.width / 2)
    target?.physicsBody?.categoryBitMask = targetCategory
    target?.physicsBody?.collisionBitMask = 0
    
  }
  
  func createPlayer() {
    player = SKSpriteNode(imageNamed: "player")
    player?.physicsBody = SKPhysicsBody(circleOfRadius: (player?.size.width)! / 2)
    player?.physicsBody?.linearDamping = 0
    player?.physicsBody?.categoryBitMask = playerCategory
    
    // Deactivate collisions so it doesn't push others about
    player?.physicsBody?.collisionBitMask = 0
    player?.physicsBody?.contactTestBitMask = enemyCategory | targetCategory | powerUpCategory
    
    guard let playerPos = tracks?.first?.position.x else { return }
    
    player?.position = CGPoint(x: playerPos, y: self.size.height / 2)
    
    self.addChild(player!)
    
    if let pulse = SKEmitterNode(fileNamed: "Pulse.sks") {
      player?.addChild(pulse)
      pulse.position = CGPoint(x: 0, y: 0)
    }
    
  }
  
  func createEnemy(type: Enemies, forTrack track:Int) -> SKShapeNode? {
    let enemySprite = SKShapeNode()
    enemySprite.name = "ENEMY"
    
    switch type {
    case .small:
      enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 40), cornerWidth: 8, cornerHeight: 8, transform: nil)
      enemySprite.fillColor = GameHandler.shared.pink
      // UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
    case .medium:
      enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 70), cornerWidth: 8, cornerHeight: 8, transform: nil)
      enemySprite.fillColor = GameHandler.shared.green
      // UIColor(red: 0.7804, green: 0.4039, blue: 0.7451, alpha: 1)
    case .large:
      enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 100), cornerWidth: 8, cornerHeight: 8, transform: nil)
      enemySprite.fillColor = GameHandler.shared.indigo
      // UIColor(red: 0.7804, green: 0.6392, blue: 0.4039, alpha: 1)
    }
    
    guard let enemyPosition = tracks?[track].position else { return nil }
    
    let up = directionArray[track]
    
    enemySprite.position.x = enemyPosition.x
    enemySprite.position.y = up ? -130 : self.size.height + 130
    
    // Edges don't have volume or mass so we don't need to change anything about its collisions
    enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
    enemySprite.physicsBody?.categoryBitMask = enemyCategory
    enemySprite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
    
    return enemySprite
    
  }
  
  func createPowerUp(forTrack track: Int) -> SKSpriteNode? {
    let powerUpSprite = SKSpriteNode(imageNamed: "powerUp")
    // Set it to enemy because we already wrote the logic for removing enemies
    powerUpSprite.name = "ENEMY"
    
    powerUpSprite.physicsBody = SKPhysicsBody(circleOfRadius: powerUpSprite.size.width / 2)
    powerUpSprite.physicsBody?.linearDamping = 0
    powerUpSprite.physicsBody?.categoryBitMask = powerUpCategory
    powerUpSprite.physicsBody?.collisionBitMask = 0
    
    let up = directionArray[track]
    guard let powerUpXPosition = tracks?[track].position.x else { return nil }
    
    powerUpSprite.position.x = powerUpXPosition
    powerUpSprite.position.y = up ? -130 : self.size.height + 130
    
    powerUpSprite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: velocityArray[track])
    
    return powerUpSprite
    
  }
  
}
