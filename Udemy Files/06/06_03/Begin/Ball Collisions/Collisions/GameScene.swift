//
//  GameScene.swift
//  Collisions
//
//  Created by Brian Advent on 04.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        
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
        
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
