//
//  ScrollingBackground.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 11/09/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import SpriteKit

class ScrollingBackground: SKSpriteNode {
  
  var scrollingSpeed: CGFloat = 0
  
  static func scrollingNodeWithImage(imageName image:String, containerWidth width:CGFloat) -> ScrollingBackground? {
    
    if let bgImage = UIImage(named: image) {
      let scrollNode = ScrollingBackground(color: UIColor.clear, size: CGSize(width: width, height: bgImage.size.height))
      
      scrollNode.scrollingSpeed = 1
      
      var totalWidthNeeded: CGFloat = 0
      
      while totalWidthNeeded < width + bgImage.size.width {
        let child = SKSpriteNode(imageNamed: image)
        child.anchorPoint = CGPoint.zero
        child.position = CGPoint(x: totalWidthNeeded, y: 0)
        scrollNode.addChild(child)
        totalWidthNeeded += child.size.width
        
      }
      
      return scrollNode
      
    }
    
    print("Error: can't create bgImage")
    return nil
    
  }
  
  func update(currentTime: TimeInterval) {
    for child in self.children {
      child.position = CGPoint(x: child.position.x - self.scrollingSpeed, y: child.position.y)
      
      if child.position.x <= -child.frame.size.width {
        let delta = child.position.x + child.frame.size.width
        child.position = CGPoint(x: child.frame.size.width * CGFloat(self.children.count - 1) + delta, y: child.position.y)
        
        
      }
      
    }
  }
  
}
