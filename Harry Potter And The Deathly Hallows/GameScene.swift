//
//  GameScene.swift
//  Harry Potter And The Deathly Hallows
//
//  Created by [ r∆ven ] on 4/15/16.
//  Copyright (c) 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Used to keep score.
    var score = 0
    var highscore = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var gameOver = 0
    var gamesPlayed = 0
    var timer = NSTimer()
    // Node to group objects.
    var movingObjects = SKNode()
    
    // Create main SPRITE NODE.
    var bird = SKSpriteNode()
    // Create background SPRITE NODE.
    var background = SKSpriteNode()
    
    var labelHolder = SKSpriteNode()
    
    // Collision groups.
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    let gapGroup:UInt32 = 0 << 3 // Bitwise mask.
    
    override func didMoveToView(view: SKView)
    {
        self.physicsWorld.contactDelegate = self
        
        // Set gravity level.
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        self.addChild(movingObjects)
        
        // Score Label
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        //*** BACKGROUND *** TIME 12:06
        
        // Create background texture.
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        
        // Create background action(-10 pixels, nothing y, every tenth second).
        // Replace -10 for size of texture/image (900px).
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)    // Moves once.
        // Add action move the image back to the beginning.
        let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        // Create action to run previous two actions in sequence.
        let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for var i:CGFloat = 0; i<3; i++ {
            
            // Assign texture to background NODE.
            background = SKSpriteNode(texture: backgroundTexture)
            
            // Assign a position for the background.
            // Width of image / 2 left edge or x.
            background.position = CGPoint(x: backgroundTexture.size().width/2+backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
            // Set background to stretch to device vertically not horizontally.
            background.size.height = self.frame.height
            
            // Set runAction method.
            background.runAction(moveBackgroundForever)
            background.zPosition = 5
            movingObjects.addChild(background)
            
        }
        
        
        //*** FLAPPY BIRD *** TIME 12:06
        
        // Create texture objects from image files.
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        // Create animation object by defining images in an [array] to display tenth of a second.
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        // Add action object to run forever.
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        
        // Assign texture to bird NODE.
        bird = SKSpriteNode(texture: birdTexture)
        // Assign a position for the bird.
        bird.position = CGPoint(x: CGRectGetMidX(self.frame)-45, y: CGRectGetMidY(self.frame))
        
        // Set runAction method.
        bird.runAction(makeBirdFlap)
        
        // Add physics to bird shape.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        // Make bird react to gravitys.
        bird.physicsBody?.dynamic = true
        // Don't allow bird to spin around.
        bird.physicsBody?.allowsRotation = false
        
        // Create collision groups.
        bird.physicsBody?.categoryBitMask = birdGroup
        // Add collision and contact mask.
        bird.physicsBody?.collisionBitMask = objectGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        
        // Set z position of bird - layer or position in front or back of other objects.
        bird.zPosition = 10
        // Adds the new sprite object to the screen.
        self.addChild(bird)
        
        //*** THE GROUND NODE ***
        
        let ground = SKNode() // No texture sprite.
        ground.position = CGPointMake(0, 0) // Start bottom left.
        // Rectangle the width of the screen with 1 pix height.
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        // Ground is not affected by gravity.
        ground.physicsBody?.dynamic = false
        
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        print("timer")
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"),
            userInfo: nil, repeats: true)
        
        
    }
    
    func makePipes()
    {
        
        //*** THE PIPE NOES***
        
        // Pipe gap.
        let gapHeight = bird.size.height * 4
        
        // Range of pipe movement - arc4random is part of the Standard C library.
        // Random number between zero and half of the screen size limits the starting
        // point of the pipe from off the screen to half way on the screen.
        let movementAmount = arc4random() % UInt32(self.frame.size.height / 2)
        // Pipe movement from starting point is a quarter of the screen size.
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 6
        
        // Move pipes ONCE aong the x axis (set the width 2 * frame, y stays still, duration uses a timer.)
        
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        print("pipe")
        
        
        // Remove pipes.
        let removePipes = SKAction.removeFromParent()
        
        // Combine move and remove pipes.
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        let pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + pipeOffset)
        // Apply pipe x movement.
        pipe1.runAction(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        
        pipe1.physicsBody?.categoryBitMask = objectGroup
        pipe1.zPosition = 15
        
        movingObjects.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + pipeOffset)
        // Apply pipe x movement.
        pipe2.runAction(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        
        pipe2.physicsBody?.categoryBitMask = objectGroup
        pipe2.zPosition = 15
        movingObjects.addChild(pipe2)
        
        
        // Scoring gap.
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody?.dynamic = false
        gap.physicsBody?.collisionBitMask = gapGroup
        gap.physicsBody?.categoryBitMask = gapGroup
        gap.physicsBody?.contactTestBitMask = birdGroup
        movingObjects.addChild(gap)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        print("Contact")
        
        // Contact to gap?
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup
            
        {
            score++
            scoreLabel.text = "\(score)"
            print("gap contact")
            
        } else {
            
            if gameOver == 0 {
                
                gameOver = 1
                movingObjects.speed = 0
                timer.invalidate()
                if score > highscore {
                    highscore = score
                }
                
                if score > NSUserDefaults.standardUserDefaults().integerForKey("highscore"){
                    NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "highscore")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                if gamesPlayed == 0{
                    self.addChild(gameOverLabel)
                }
                gamesPlayed++
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)// CODE ?????????????????? TIME 4:30
    {
        if (gameOver==0)
        {
            // Set speed of bird to zero.
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            // Apply an impulse or force to the bird.
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        }
        if (gameOver==1)
        {
            
            // Set speed of bird to zero.
            bird.physicsBody?.velocity = CGVectorMake(0, 0)
            // Apply an impulse or force to the bird.
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
            //SKAction.sequence([movePipes, removePipes])
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"),
                userInfo: nil, repeats: true)
            movingObjects.speed = 1
            score = 0
            scoreLabel.text = "\(score)"
            gameOver = 0
        }
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
