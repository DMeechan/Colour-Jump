//
//  GameScene.swift
//  Collisions
//
//  Created by Brian Advent on 04.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let redBallCategory:UInt32  = 0x1 << 0 // 1
    let blueBallCategory:UInt32 = 0x1 << 1 // 2
    let groundCategory:UInt32   = 0x1 << 2 // 4
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        let ballRadius: CGFloat = 20
        let redBall = SKShapeNode(circleOfRadius: ballRadius)
        redBall.fillColor = .red
        redBall.position = CGPoint(x: 280, y: 320)
        redBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        self.addChild(redBall)
        
        let blueBall = SKShapeNode(circleOfRadius: ballRadius)
        blueBall.fillColor = .blue
        blueBall.position = CGPoint(x: 360, y: 320)
        blueBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        
        self.addChild(blueBall)
        
        var splinePoints = [CGPoint(x: 0, y: 300),
                            CGPoint(x: 100, y: 50),
                            CGPoint(x: 400, y: 110),
                            CGPoint(x: 640, y: 20)]
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.75
        
        self.addChild(ground)
        
        ground.physicsBody?.categoryBitMask = groundCategory
        redBall.physicsBody?.collisionBitMask = groundCategory
        blueBall.physicsBody?.collisionBitMask = groundCategory
        
        redBall.physicsBody?.categoryBitMask = redBallCategory
        ground.physicsBody?.contactTestBitMask = redBallCategory
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == groundCategory | redBallCategory {
            print("Collision with Red Ball Occured")
        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
