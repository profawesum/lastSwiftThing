//
//  GameScene.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 30/09/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import SpriteKit
//import GameplayKit

class GameScene: SKScene {
    
    var quitlabel : SKLabelNode!
    var square = SKSpriteNode()
    let ball = SKShapeNode(circleOfRadius: 20)
    let playerColors = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.green]
    var label : SKLabelNode!
    
    var score = 0
    var timeToFall = 3.0
    var i = 0
    var Playerloss = false
    
    private let node = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        gameLoop()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        label.text = "Score: \(score)"
        
        if(score > 10){
            timeToFall = 2.0
        }
        
        if !ball.hasActions()
        {
            if(ball.fillColor == square.color){
                score += 1
                ball.position = CGPoint(x: self.frame.midX , y: self.frame.maxY + 10)
                randomBallColor()
            }
            else {
                //return to menu
                UserDefaults.standard.set(score, forKey: "PreviousScore")
                let newScene = GameOver(size:(self.view?.bounds.size)!)
                let transition = SKTransition.reveal(with: .down, duration: 2)
                self.view?.presentScene(newScene, transition: transition)
                transition.pausesOutgoingScene = true
                transition.pausesIncomingScene = false
            }
        }
    }
    
    func gameLoop(){
        
        
        //ball.size =  CGSize(width: 64, height: 64)
        ball.position = CGPoint(x: self.frame.midX , y: self.frame.maxY + 10)
        ball.fillColor = UIColor.green
        self.addChild(ball)
        
        
        //player sprite
        square = SKSpriteNode(texture: SKTexture(imageNamed: "ColorWheel"), size: CGSize(width: 200, height: 200))
        square.position = CGPoint(x: self.frame.width/2, y: self.frame.minY + 150)
        square.color = UIColor.blue
        self.addChild(square)
        
        //score label
        label = SKLabelNode();
        label.text = "Score: \(score)"
        label.fontSize = 32.0
        label.fontName = "AvenirNext-Bold"
        label.fontColor = UIColor.red
        label.position = CGPoint(x : self.frame.midX, y: self.frame.midY*1.75)
        self.addChild(label)
        
        //quit Button Label
        quitlabel = SKLabelNode()
        quitlabel.text = "Quit"
        quitlabel.fontSize = 32.0
        quitlabel.fontName = "AvenirNext-Bold"
        quitlabel.fontColor = UIColor.red
        quitlabel.position = CGPoint(x : self.frame.midX - 150, y: self.frame.midY * 1.75)
        self.addChild(quitlabel);
        
        randomBallColor();
        
    }
    
    func randomBallColor(){
        ball.run(SKAction.fadeIn(withDuration: 1))
        let number = Int.random(in: 0 ... 3)
        ball.fillColor = playerColors[number]
        ballFall();
    }
    
    func ballFall(){
        ball.run(SKAction.moveBy(x: 0, y: self.frame.minY - 760, duration: timeToFall))
        let fadeOutAction = SKAction.fadeOut(withDuration: 2)
        let waitAction = SKAction.wait(forDuration: 2)
        ball.run(SKAction.sequence([waitAction, fadeOutAction]))
        
    }
    
    
    //rotates the square
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        
        if(quitlabel.contains(location!)){
            
            UserDefaults.standard.set(score, forKey: "PreviousScore")
            let newScene = MainMenu(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 2)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
        
        if(location!.x < self.frame.width/2){
            
            square.run(SKAction.rotate(byAngle: CGFloat((Float.pi*90)/180), duration: 1))
            //used to change the color of the square
            i += 1
            if(i > 3){
                i = 0
            }
            square.color = playerColors[i]
        }
        else{
            
            square.run(SKAction.rotate(byAngle: -CGFloat((Float.pi*90)/180), duration: 1))
            //used to change the color of the square
            i -= 1
            if(i < 0){
                i = 3
            }
            square.color = playerColors[i]
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            if node.contains(location){
                node.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            if node.contains(location){
                node.size = CGSize(width: node.size.width * 0.5, height : node.size.height * 0.5)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Cancelled")
    }
}



