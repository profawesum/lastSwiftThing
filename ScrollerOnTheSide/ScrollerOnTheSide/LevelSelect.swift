//
//  LevelSelect.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 14/10/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import SpriteKit

class LevelSelect: SKScene{

    //title label
    var titleLabel : SKLabelNode!
    //level buttons
    var levelOneLabel : SKLabelNode!
    var levelTwoLabel : SKLabelNode!
    
    var tapped: Bool = false
    
    
    override func update(_ currentTime: TimeInterval) {

        
    }
    
    override func didMove(to view: SKView) {
        
     //  let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
     //  doubleTap.numberOfTapsRequired = 1
     //  view.addGestureRecognizer(doubleTap)
        
        // making the title label
        titleLabel = SKLabelNode();
        titleLabel.text = "Level Select"
        titleLabel.fontSize = 68.0
        titleLabel.fontName = "AvenirNext-Bold"
        titleLabel.fontColor = UIColor.white
        titleLabel.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.75)
        self.addChild(titleLabel);
        
        // making level one label
        levelTwoLabel = SKLabelNode();
        levelTwoLabel.text = "Level Two"
        levelTwoLabel.fontSize = 32.0
        levelTwoLabel.fontName = "AvenirNext-Bold"
        levelTwoLabel.fontColor = UIColor.white
        levelTwoLabel.position = CGPoint(x : self.frame.midX * 1.25, y: self.frame.midY*1.25)
        self.addChild(levelTwoLabel);
        
        // making level two label
        levelOneLabel = SKLabelNode();
        levelOneLabel.text = "Level One"
        levelOneLabel.fontSize = 32.0
        levelOneLabel.fontName = "AvenirNext-Bold"
        levelOneLabel.fontColor = UIColor.white
        levelOneLabel.position = CGPoint(x : self.frame.midX / 1.25, y: self.frame.midY*1.25)
        self.addChild(levelOneLabel);

        //background track
        let backgroundAudioNode = SKAudioNode(fileNamed: "menuMusic.wav")
        backgroundAudioNode.autoplayLooped = true
        //decrease the volume of the music
        backgroundAudioNode.run(SKAction.changeVolume(by: 2, duration: 0))
        self.addChild(backgroundAudioNode)
        backgroundAudioNode.run(SKAction.play())
        
        self.backgroundColor = UIColor.black
        
    }
    
    @objc func doubleTapped(){
        tapped = true
    }
    //on touches began 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if(levelOneLabel.contains(location!)){//} && tapped){
            //tapped = false
            let newScene = LevelOne(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 0.5)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
        if(levelTwoLabel.contains(location!)){//} && tapped){
            //tapped = false
            let newScene = LevelTwo(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 0.5)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
    }
}
