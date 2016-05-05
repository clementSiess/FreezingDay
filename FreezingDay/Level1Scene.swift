//
//  Level1Scene.swift
//  FreezingDay
//
//  Created by Mac on 10/9/15.
//  Copyright © 2015 clement siess. All rights reserved.
//

import SpriteKit
import AVFoundation


enum PhysicsCategory: UInt32 {
    case Car = 1
    case Coin = 2
    case Snowman = 3
    case World = 4
}

class Level1Scene: SKScene, SKPhysicsContactDelegate {
    
    lazy var backgroundMusic: AVAudioPlayer = {
        let url = NSBundle.mainBundle().URLForResource("Sounds/backgroundMusic", withExtension: "mp3")
        let player = try? AVAudioPlayer(contentsOfURL: url!)
        
        if let player = player {
            player.numberOfLoops = -1
            return player
        } else {
        
            return AVAudioPlayer()
        }
    }()
    
    let coinSound = SKAction.playSoundFileNamed("Sounds/coin-sound.mp3", waitForCompletion: false)
    let hitSound = SKAction.playSoundFileNamed("Sounds/hit.wav", waitForCompletion: false)
    let jumpSound = SKAction.playSoundFileNamed("Sounds/Jump.mp3", waitForCompletion: false)

    
    var gameOver: Bool!
    var car: SKSpriteNode!
    var coin: SKSpriteNode!
    var snowman: SKSpriteNode!
    var bgImage = SKSpriteNode(imageNamed: "SnowBG")
    var onGround: Bool!
    var groundZero: CGFloat!
    var groundZeroRounded: CGFloat!
    var lastTouch: CGPoint? = nil
    var score = 0
    var scoreLabel = SKLabelNode()
    
    var healthLabel = SKLabelNode()
    var health = 4
    
    var timer = NSTimer()
    var timerLabel = SKLabelNode()
    var seconds = 45
    
    let particles = SKEmitterNode(fileNamed: "SnowParticle.sks")
    let carSmoke = SKEmitterNode(fileNamed: "SmokeCar.sks")
    
    override func didMoveToView(view: SKView) {
        
        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        bgImage.zPosition = -2
        self.addChild(bgImage)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0 )
        self.physicsWorld.contactDelegate = self
        
        createGround()
        createSnowman()
        createCar()
        createCoin()
        
        addObserver()
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "MarkerFelt-Thin"
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position.y = ((self.size.height/3) * 2.7)
        scoreLabel.position.x = ((self.size.width/3) * 2.7)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        healthLabel = SKLabelNode(text: "Life: 4")
        healthLabel.fontName = "MarkerFelt-Thin"
        healthLabel.fontColor = SKColor.blackColor()
        healthLabel.position.y = ((self.size.height/3) * 2.7)
        healthLabel.position.x = ((self.size.width/3) * 0.3)
        healthLabel.zPosition = 1
        self.addChild(healthLabel)
        
        timerLabel = SKLabelNode(text: "Time: 45")
        timerLabel.fontName = "MarkerFelt-Thin"
        timerLabel.fontColor = SKColor.blackColor()
        timerLabel.colorBlendFactor = 1
        timerLabel.position.y = ((self.size.height/3) * 2.7)
        timerLabel.position.x = ((self.size.width/2))
        timerLabel.zPosition = 1
        self.addChild(timerLabel)
        
        gameOver = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("substractTime"), userInfo: nil, repeats: true)
        
        particles?.position = CGPointMake(self.size.width/2, self.size.height)
        particles?.zPosition = 1
        self.addChild(particles!)
        
        backgroundMusic.play()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !gameOver{
            
            if !paused{
            
                if (self.onGround == true) {
                    let touch = touches.first as UITouch!
                    let touchLocation = touch.locationInNode(self)
                    lastTouch = touchLocation
                
                    if let _ = lastTouch {
                        car.physicsBody?.applyImpulse(CGVector(dx: 0,dy: 140))
                        runAction(jumpSound)
                    }
                }
            }
        }
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        
        if !gameOver{
            
            if (self.car.position.y - car.size.height/3) <= groundZeroRounded {
                onGround = true
                
            } else {
                onGround = false
            }
        }
    }
    
    
    func createGround(){
        let groundTexture = SKTexture(imageNamed: "frozenGround")
        groundTexture.filteringMode = .Nearest
        
        let moveGround = SKAction.moveByX(-groundTexture.size().width * 1.5, y: 0, duration: NSTimeInterval(0.01 * groundTexture.size().width * 2))
        let resetGround = SKAction.moveByX(groundTexture.size().width * 1.5, y: 0, duration: 0.0)
        let moveGroundForever = SKAction.repeatActionForever(SKAction.sequence([moveGround, resetGround]))
        
        for var i: CGFloat = 0; i < 2.0 + self.frame.size.width / (groundTexture.size().width * 2.0); ++i {
            let sprite = SKSpriteNode(texture: groundTexture)
            sprite.setScale(1.5)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 6.5)
            
            sprite.runAction(moveGroundForever)
            
            let square = CGSize(width: groundTexture.size().width * 2.0, height: groundTexture.size().height * 1.5)
            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: square)
            sprite.physicsBody?.dynamic = false
            sprite.zPosition = -1.0
            self.addChild(sprite)
            
        }
    }
    
    func createCar(){
        let atlas = SKTextureAtlas(named: "car")
        
        var walkFrames = [SKTexture]()
        for i in 1 ... 3 {
            walkFrames.append(atlas.textureNamed("car\(i)"))
        }
        
        car = SKSpriteNode(texture: walkFrames[0] as SKTexture)
        
        car.xScale = 0.6
        car.yScale = 0.6
        car.position = CGPoint(x:size.width * 0.1, y: size.height * 0.3)
        car.physicsBody = SKPhysicsBody(rectangleOfSize: car.size)
        car.physicsBody?.allowsRotation = false
        car.physicsBody!.dynamic = true
        car.physicsBody!.velocity = CGVectorMake(100, 0)
        car.physicsBody!.mass = 1
        car.physicsBody?.density = 4
        car.name = "car"
        car.physicsBody?.usesPreciseCollisionDetection = true
        car.physicsBody?.categoryBitMask = PhysicsCategory.Car.rawValue
        
        car.physicsBody?.collisionBitMask =  PhysicsCategory.Snowman.rawValue
        car.physicsBody!.contactTestBitMask = PhysicsCategory.Car.rawValue | PhysicsCategory.Snowman.rawValue
        
        let runAnimation = SKAction.animateWithTextures(walkFrames, timePerFrame:0.01, resize: true, restore:false)
        let repeatAction = SKAction.repeatActionForever(runAnimation)
        car.runAction(repeatAction)
        car.zPosition = -0.5
        
        self.addChild(car)
        
        carSmoke?.position = CGPoint(x:size.width * 0.11, y:-20)
        car.addChild(carSmoke!)
        car.xScale = car.xScale * -1
        
        groundZero = car.position.y
        groundZeroRounded = CGFloat((round(100*groundZero)/100) + 1)
    }
    
    func createCoin(){
        let atlasCoinTexture = SKTextureAtlas(named: "coin")
        
        var coinSpining = [SKTexture]()
        
        for i in 1 ... 8 {
            coinSpining.append(atlasCoinTexture.textureNamed("coin\(i)"))
    }
        
        coin = SKSpriteNode(texture: coinSpining[0] as SKTexture)
        coin.xScale = 0.5
        coin.yScale = 0.5
        coin.position = CGPoint(x:size.width * 0.7, y: size.height * random(0.4, max: 1))
        coin.name = "coin"
        coin.physicsBody = SKPhysicsBody(rectangleOfSize: coin.frame.size)
        coin.physicsBody?.allowsRotation = false
        coin.physicsBody?.density = 0.1
        coin.physicsBody?.usesPreciseCollisionDetection = true
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin.rawValue
        coin.physicsBody?.collisionBitMask = PhysicsCategory.Coin.rawValue | PhysicsCategory.Car.rawValue
        coin.physicsBody!.contactTestBitMask = PhysicsCategory.Coin.rawValue | PhysicsCategory.Car.rawValue

        let runAnimation = SKAction.animateWithTextures(coinSpining, timePerFrame:0.2, resize: true, restore:false)
        let repeatAction = SKAction.repeatActionForever(runAnimation)
        coin.runAction(repeatAction)
        coin.zPosition = -0.5
        self.addChild(coin)
        moveCoin()
    }
    
    func moveCoin(){
        let moveCoin = SKAction.moveByX(-coin.size.width * 55, y: 0, duration: NSTimeInterval(0.01 * coin.size.width * 15))
        let resetCoin = SKAction.moveByX(coin.size.width * 60, y: 0, duration: 0.0)
        
        let moveCoinForever = SKAction.repeatActionForever(SKAction.sequence([moveCoin, resetCoin]))
        
        coin.runAction(moveCoinForever)
        
    }
    
    func createSnowman(){
        let atlasSnowmanTexture = SKTextureAtlas(named: "snowman")
        
        var snowmanMove = [SKTexture]()
        for i in 1 ... 5 {
            snowmanMove.append(atlasSnowmanTexture.textureNamed("snowman\(i)"))
        }
        
        snowman = SKSpriteNode(texture: snowmanMove[0] as SKTexture)
        snowman.xScale = 0.5
        snowman.yScale = 0.5
        snowman.position = CGPoint(x:size.width * 0.8 + 0.3, y: size.height * random(0.5, max: 1))
        snowman.name = "smowman"
        snowman.physicsBody = SKPhysicsBody(rectangleOfSize: snowman.frame.size)
        snowman.physicsBody?.allowsRotation = false
        snowman.physicsBody!.mass = 0.6
        snowman.physicsBody?.density = 0.5
        snowman.physicsBody?.usesPreciseCollisionDetection = true
        snowman.physicsBody?.categoryBitMask = PhysicsCategory.Snowman.rawValue
        snowman.physicsBody?.collisionBitMask = PhysicsCategory.Snowman.rawValue | PhysicsCategory.Car.rawValue
        snowman.physicsBody!.contactTestBitMask = PhysicsCategory.Snowman.rawValue | PhysicsCategory.Car.rawValue
        snowman.zPosition = -0.5
        
        let runAnimation = SKAction.animateWithTextures(snowmanMove, timePerFrame:0.2, resize: true, restore:false)
        let repeatAction = SKAction.repeatActionForever(runAnimation)
        snowman.runAction(repeatAction)
        self.addChild(snowman)
        moveSnowman()
    }
    
    func moveSnowman(){
        let moveSnowman = SKAction.moveByX(-snowman.size.width * 55, y: 0, duration: NSTimeInterval(0.01 * snowman.size.width * 25))
        let resetSnowman = SKAction.moveByX(snowman.size.width * 60, y: 0, duration: 0.0)
        
        let moveSnowmanForever = SKAction.repeatActionForever(SKAction.sequence([moveSnowman, resetSnowman]))
        
        snowman.runAction(moveSnowmanForever)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if !gameOver{
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            if (firstBody.categoryBitMask == PhysicsCategory.Car.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.Coin.rawValue){
                
                runAction(coinSound)
                updateScore()
                coin.removeFromParent()
                createCoin()
                
            } else if(firstBody.categoryBitMask == PhysicsCategory.Car.rawValue) && (secondBody.categoryBitMask == PhysicsCategory.Snowman.rawValue){
                
                runAction(hitSound)
                updateHealth()
                shakeNode(car)
                fadeOutPlayer()
                snowman.removeFromParent()
                
                if !gameOver{
                        createSnowman()
                }
            }
        }
    }
    
    func random() ->CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) ->CGFloat {
        return random() * (max - min) + min
    }
    
    func updateScore(){
        score++
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateHealth() {
        health--
        healthLabel.text = "Life: \(health)"
        
        if health == 0 {
            gameOver = true
            self.removeAllChildren()
            goToGameOver()
        }
    }
    
    func fadeOutPlayer(){
        car.alpha -= 0.25
    }
    
    func shakeNode(node: SKNode){
        node.removeActionForKey("shake")
        let shakeSteps = 15
        let shakeDistance = 20.0
        let shakeDuration = 0.25
        
        var shakeActions : [SKAction] = []
        
        for i in 0...shakeSteps{
            let shakeMovementDuration : Double = shakeDuration / Double(shakeSteps)
            
            let shakeAmount : Double = Double(shakeSteps - i) / Double(shakeSteps)
            var shakePosition = node.position
            
            let xPos = (Double(arc4random_uniform(UInt32(shakeDistance*2))) - Double(shakeDistance)) * shakeAmount
            let yPos = (Double(arc4random_uniform(UInt32(shakeDistance*2))) - Double(shakeDistance)) * shakeAmount
            
            shakePosition.x = shakePosition.x + CGFloat(xPos)
            shakePosition.y = shakePosition.y + CGFloat(yPos)
            
            let shakeMovementAction = SKAction.moveTo(shakePosition, duration: shakeMovementDuration)
            shakeActions.append(shakeMovementAction)
        }
        
        let shakeSequence = SKAction.sequence(shakeActions)
        node.runAction(shakeSequence, withKey: "shake")
    }
    
    func substractTime(){

          if seconds > 0 {
            seconds--
            timerLabel.text = "Time: \(seconds)"
          } else{
            timer.invalidate()
            goToWinView()
          }
    }
    
    func pauseSubstractTime() {
          timer.invalidate()
    }
    
    
    func goToGameOver(){
        self.removeAllChildren()
        timer.invalidate()
        
        let scene = GameOverScene(size: self.size)
        let sKView = self.view as SKView!
        sKView.ignoresSiblingOrder = false
        scene.scaleMode = .ResizeFill
        scene.size = sKView.bounds.size
        
        scene.gameScene = self
        scene.score = score
        
        NSNotificationCenter.defaultCenter().postNotificationName("setHidePauseButton", object: nil)

        sKView.presentScene(scene)
    }
    
    func goToWinView(){
        self.removeAllChildren()
        
        let scene = WiningScene(size: self.size)
        let sKView = self.view as SKView!
        sKView.ignoresSiblingOrder = false
        scene.scaleMode = .ResizeFill
        scene.size = sKView.bounds.size
        
        scene.gameScene = self
        scene.score = score
        
        NSNotificationCenter.defaultCenter().postNotificationName("setHidePauseButton", object: nil)

        sKView.presentScene(scene)
    }

    
    func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("restartTimer"), name: "restartTimer", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pauseSubstractTime"), name: "pauseSubstractTime", object: nil)
    }
    
    func restartTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("substractTime"), userInfo: nil, repeats: true)
        if seconds > 0 {
            seconds--
            timerLabel.text = "Time: \(seconds)"
        }
    }
    
    
}