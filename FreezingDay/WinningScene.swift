//
//  WinningScene.swift
//  FreezingDay
//
//  Created by Mac on 10/9/15.
//  Copyright © 2015 clement siess. All rights reserved.
//


import SpriteKit

class WiningScene: SKScene, SKPhysicsContactDelegate  {
    
    var gameScene = Level1Scene()
    var winLabel = UILabel()
    var scoreLabel = UILabel()
    var playAgainButton = UIButton()
    
    var score: Int!
    
    override func didMoveToView(view: SKView) {
        
        winLabel.text = "You Win!"
        winLabel.font = UIFont(name: "MarkerFelt-Thin", size: 45)
        winLabel.textColor = UIColor.greenColor()
        winLabel.textAlignment = .Center
        winLabel.frame = CGRectMake(35, 54, 300, 500)
        
        scoreLabel.text = "Score: \(gameScene.score)"
        scoreLabel.font = UIFont(name: "MarkerFelt-Thin", size: 45)
        scoreLabel.textColor = UIColor.purpleColor()
        scoreLabel.textAlignment = .Center
        scoreLabel.frame = CGRectMake(335, 54, 300, 500)
        
        playAgainButton.setTitle("✸Play Again", forState: .Normal)
        playAgainButton.titleLabel!.font = UIFont(name: "MarkerFelt-Thin", size: 45)!
        playAgainButton.backgroundColor = UIColor.whiteColor()
        playAgainButton.alpha = 0.5
        playAgainButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        playAgainButton.frame = CGRectMake(35, -50, 300, 500)
        playAgainButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.view!.addSubview(winLabel)
        self.view!.addSubview(playAgainButton)
        self.view!.addSubview(scoreLabel)
    }
    
    
    
    
    func pressed(sender: UIButton!) {
        winLabel.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        let scene = Level1Scene(size: self.size)
        let sKView = self.view as SKView!
        sKView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = sKView.bounds.size
        
        NSNotificationCenter.defaultCenter().postNotificationName("setHidePauseButton", object: nil)

        sKView.presentScene(scene)
    }
    
}

