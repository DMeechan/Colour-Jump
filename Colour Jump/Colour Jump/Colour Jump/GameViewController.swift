//
//  GameViewController.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 31/08/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let wrapperView = SKView(frame: self.view.bounds)
    self.view.addSubview(wrapperView)
    
    // Load the SKScene from 'GameScene.sks'
    if let scene = SKScene(fileNamed: "StartScene") {
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .aspectFill
      
      // Present the scene
      wrapperView.presentScene(scene)
    }
    
    wrapperView.ignoresSiblingOrder = true
    
    wrapperView.showsFPS = true
    wrapperView.showsNodeCount = true
    
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
