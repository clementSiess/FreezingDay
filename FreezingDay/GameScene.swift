//
//  GameScene.swift
//  FreezingDay
//
//  Created by Mac on 10/9/15.
//  Copyright (c) 2015 clement siess. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    
    let playButton = SKSpriteNode(imageNamed: "icyDayButton")
    
    override func didMoveToView(view: SKView) {
        
        self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(self.playButton)
        
        self.backgroundColor = UIColor.blueColor()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.playButton{

                let scene = Level1Scene(size: self.size)
                let sKView = self.view as SKView!
                sKView.ignoresSiblingOrder = false
                scene.scaleMode = .ResizeFill
                scene.size = sKView.bounds.size
                
                NSNotificationCenter.defaultCenter().postNotificationName("setHidePauseButton", object: nil)


                sKView.presentScene(scene)
            }
        }
        
    }
    
    
}
