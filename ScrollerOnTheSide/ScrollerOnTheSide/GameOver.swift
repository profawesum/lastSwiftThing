//
//  GameOver.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 14/10/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import SpriteKit

class GameOver: SKScene{
    
    var square = SKSpriteNode()
    let left = SKSpriteNode();
    let right = SKSpriteNode()
    var titleLabel : SKLabelNode!
    var playLabel : SKLabelNode!
    var scoreLabel : SKLabelNode!
    var highScoreLabel : SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        
        //background track
        let backgroundAudioNode = SKAudioNode(fileNamed: "menuMusic.wav")
        //backgroundAudioNode = SKAudioNode(fileNamed: "BackingTrack.wav")
        backgroundAudioNode.autoplayLooped = true
        //decrease the volume of the music
        backgroundAudioNode.run(SKAction.changeVolume(by: 2, duration: 0))
        self.addChild(backgroundAudioNode)
        backgroundAudioNode.run(SKAction.play())
        
        
        // making the title label
        titleLabel = SKLabelNode();
        titleLabel.text = "Game Over"
        titleLabel.fontSize = 68.0
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.75)
        self.addChild(titleLabel);
        
        playLabel = SKLabelNode();
        playLabel.text = "You DIED"
        playLabel.fontSize = 68.0
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.25)
        self.addChild(playLabel);
        
        
        scoreLabel = SKLabelNode();
        scoreLabel.text = "Main Menu"
        scoreLabel.fontSize = 32.0
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY/1.5)
        self.addChild(scoreLabel);
        
        self.backgroundColor = UIColor.black
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if(scoreLabel.contains(location!)){
            let newScene = MainMenu(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 2)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = false
            transition.pausesIncomingScene = false
        }
    }
}
