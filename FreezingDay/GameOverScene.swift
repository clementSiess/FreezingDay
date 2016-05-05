//
//  GameOverScene.swift
//  FreezingDay
//
//  Created by Mac on 10/9/15.
//  Copyright © 2015 clement siess. All rights reserved.
//

import SpriteKit


class GameOverScene: SKScene, SKPhysicsContactDelegate  {
    
    var gameScene = Level1Scene()
    
    var gameOverLabel = UILabel()
    var scoreLabel = UILabel()
    
    var playAgainButton = UIButton()
    var score: Int!
    
    override func didMoveToView(view: SKView) {
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.font = UIFont(name: "MarkerFelt-Thin", size: 45)
        gameOverLabel.textColor = UIColor.redColor()
        gameOverLabel.textAlignment = .Center
        gameOverLabel.frame = CGRectMake(35, 54, 300, 500)
        
        
        
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
        playAgainButton.frame = CGRectMake(35, -50, 300, 200)
        playAgainButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        self.view!.addSubview(gameOverLabel)
        self.view!.addSubview(playAgainButton)
        self.view!.addSubview(scoreLabel)
        
    }
    
    
    
    
    func pressed(sender: UIButton!) {
        gameOverLabel.removeFromSuperview()
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

