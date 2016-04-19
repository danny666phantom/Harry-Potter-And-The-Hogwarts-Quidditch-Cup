//
//  GameViewController.swift
//  Harry Potter And The Deathly Hallows
//
//  Created by [ r∆ven ] on 4/15/16.
//  Copyright (c) 2016 Salt Lake Community College. All rights reserved.
//

import UIKit
import SpriteKit
// For custom sound effect from segue entrance touch.
import AVFoundation

class GameViewController: UIViewController {
    
    var magicSound: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom magic sound effect.
        magicButtonSound()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // Magic sound function.
    private func magicButtonSound(){
        let path = NSBundle.mainBundle().URLForResource("Harry Potter top 10 soundtracks", withExtension: "mp3")
        do {
            try magicSound = AVAudioPlayer(contentsOfURL: path!)
        } catch {
            print("AUDIO PROBLEM?!")
        }
        magicSound.play()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
