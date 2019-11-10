//
//  MainMenuScene.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 30/09/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene{
    
    var square = SKSpriteNode()
    let left = SKSpriteNode();
    let right = SKSpriteNode()
    var titleLabel : SKLabelNode!
    var playLabel : SKLabelNode!
    var scoreLabel : SKLabelNode!
    var highScoreLabel : SKLabelNode!
    var titleTwo : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        // making the title label
        titleLabel = SKLabelNode();
        titleLabel.text = "Scroller on"
        titleLabel.fontSize = 68.0
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.75)
        self.addChild(titleLabel);
        
        //title label
        titleTwo = SKLabelNode();
        titleTwo.text = "the Side"
        titleTwo.fontSize = 68.0
        titleTwo.fontName = "AvenirNext-Bold"
        titleTwo.fontColor = UIColor.white
        titleTwo.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.5)
        self.addChild(titleTwo);
        
        //label play
        playLabel = SKLabelNode();
        playLabel.text = "Play"
        playLabel.fontSize = 68.0
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY)
        self.addChild(playLabel);
        
        //background track
        let backgroundAudioNode = SKAudioNode(fileNamed: "menuMusic.wav")
        //backgroundAudioNode = SKAudioNode(fileNamed: "BackingTrack.wav")
        backgroundAudioNode.autoplayLooped = true
        //decrease the volume of the music
        backgroundAudioNode.run(SKAction.changeVolume(by: 2, duration: 0))
        self.addChild(backgroundAudioNode)
        backgroundAudioNode.run(SKAction.play())
        
        self.backgroundColor = UIColor.black
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if(playLabel.contains(location!)){
            let newScene = LevelSelect(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 0)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = false
            transition.pausesIncomingScene = false
        }
    }
}
