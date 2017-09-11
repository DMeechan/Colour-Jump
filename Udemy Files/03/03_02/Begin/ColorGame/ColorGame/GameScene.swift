//
//  GameScene.swift
//  ColorGame
//
//  Created by Brian Advent on 21.07.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var tracksArray:[SKSpriteNode]? = [SKSpriteNode]()
    
    func setupTracks(){
        for i in 0 ... 8 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
        
    }
    
    override func didMove(to view: SKView) {
        setupTracks()
        
       
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
