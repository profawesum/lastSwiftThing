//
//  GameViewController.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 30/09/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import UIKit
import SpriteKit
//import GameplayKit


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            UserDefaults.standard.set(0, forKey: "PreviousScore")
            // Load the SKScene from 'GameScene.sks'
            let scene = MainMenu(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
