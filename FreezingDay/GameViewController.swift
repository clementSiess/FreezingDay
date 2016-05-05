//
//  GameViewController.swift
//  FreezingDay
//
//  Created by Mac on 10/9/15.
//  Copyright (c) 2015 clement siess. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    @IBOutlet weak var pauseButton: UIButton!
    
    var paused: Bool = false
    var skView: CustomSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pauseButton.hidden = true

        
        let scene = GameScene(size: view.bounds.size)
        skView = view as! CustomSKView
        
        addObservers()
        
        scene.scaleMode = .ResizeFill
        
        skView.presentScene(scene)
        
    }
    
    func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(skView, selector: Selector("setStayPaused"), name: "stayPausedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setPauseButtonTitleToStart"), name: "setPauseButtonToStart", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setPauseButtonHidden"), name: "setHidePauseButton", object: nil)
    }
    
    func setPauseButtonTitleToStart() {
        
        if let button = pauseButton {
            button.setTitle("Start", forState: .Normal)
        }
        
        paused = true
    }
    
    @IBAction func togglePause(sender: AnyObject) {
        
        if !paused {
            setPauseButtonTitleToStart()
            skView.paused = true
            skView.scene!.paused = true
            paused = true
            
            NSNotificationCenter.defaultCenter().postNotificationName("pauseSubstractTime", object: nil)
            
        } else {
            pauseButton.setTitle("Pause", forState: .Normal)
            skView.paused = false
            skView.scene!.paused = false
            paused = false
            
            NSNotificationCenter.defaultCenter().postNotificationName("restartTimer", object: nil)
            
        }
        
    }
    
    func delay(delay:Double, closure:() -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setPauseButtonHidden(){
        self.pauseButton.hidden = !self.pauseButton.hidden
    }
}




