//
//  LevelOne.swift
//  CatcherOfTheColor
//
//  Created by Harrison Orsbourne on 30/09/19.
//  Copyright © 2019 Harrison Orsbourne. All rights reserved.
//

import SpriteKit

class LevelOne: SKScene, SKPhysicsContactDelegate {
    
    var quitlabel : SKLabelNode!
    var label : SKLabelNode!
    
    var node : SKNode!
    var tileMap : SKTileMapNode!
    var shapeNode : SKShapeNode!
    
    var score = 0
    
    var cameraNode: SKCameraNode!
    var player: SKSpriteNode!
    var index = 0
    let backgrounds: [String] = ["back1", "back2"]
    var back1: SKSpriteNode!
    var back2: SKSpriteNode!
    var moveAction: SKAction!
    var flyAction: SKAction!
    
    var blueNode : SKSpriteNode!
    
    var rectangle : SKSpriteNode!
    var killFloor : SKSpriteNode!
    
    var sfxNode = SKAudioNode(fileNamed: "PointsBonus.wav")

    
    var playerLose = false
    

    //setting up collision bit masks
    enum CategoryBitMask{
        
        static let redNode: UInt32 = 0b0001
        static let blueNode: UInt32 = 0b0010
        static let obstacle: UInt32 = 0b0100
        static let boundry: UInt32 = 0b1000
        
    }
    
    override func didMove(to view: SKView) {
        gameLoop()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //moves the background when it is out of the screen space
        if(!cameraNode.contains(back1) && back1.position.x < cameraNode.position.x){
            back1.position.x += 2 * back1.frame.width
        }
        else if(!cameraNode.contains(back2) && back2.position.x < cameraNode.position.x){
            back2.position.x += 2 * back2.frame.width
        }
        //moevs the ninja star when it reaches a set point
        if(blueNode.position.x < cameraNode.position.x - 50){
            score += 1
            label.text = "Score: \(score)"
            sfxNode.run(SKAction.play())
            blueNode.position.x += blueNode.frame.width + 450
        }
        
        //make sure the base is always following the player x position
        rectangle.position.x = player.position.x
        killFloor.position.x = player.position.x
        cameraNode.position = player.position
        quitlabel.position.x = player.position.x - 300
        label.position.x = player.position.x + 300
        
        //checks to see if the player has lost
        if(playerLose){
            //load the game over scene if the player has lost
            let newScene = GameOver(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 0.5)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }

        
    }
    
    //when the level loads go here
    func gameLoop(){
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CategoryBitMask.boundry
        self.physicsWorld.contactDelegate = self
        
        //score label
        label = SKLabelNode();
        label.text = "Score: \(score)"
        label.fontSize = 32.0
        label.fontName = "AvenirNext-Bold"
        label.fontColor = UIColor.red
        label.position = CGPoint(x : self.frame.midX * 1.5, y: self.frame.midY*1.75)
        self.addChild(label)
        
        //quit Button Label
        quitlabel = SKLabelNode()
        quitlabel.text = "Quit"
        quitlabel.fontSize = 32.0
        quitlabel.fontName = "AvenirNext-Bold"
        quitlabel.fontColor = UIColor.red
        quitlabel.position = CGPoint(x : self.frame.midX / 3.5, y: self.frame.midY * 1.75)
        self.addChild(quitlabel);
        
        self.listener = player
        createAction()
        createPhysicsObjects();
        createCamera()
        createBackground()
        createPlayer()
        createAudioSFX()
        
    }
    
    //loads audio sources
    func createAudioSFX(){
        
        sfxNode.autoplayLooped = false;
        sfxNode.run(SKAction.changeVolume(by: 15, duration: 0))
        self.addChild(sfxNode)
        
        //background track
        let backgroundAudioNode = SKAudioNode(fileNamed: "levelOneTrack.wav")
        backgroundAudioNode.autoplayLooped = true
        //decrease the volume of the music
        backgroundAudioNode.run(SKAction.changeVolume(by: 2, duration: 0))
        self.addChild(backgroundAudioNode)
        backgroundAudioNode.run(SKAction.play())
        
    }
    
    //calls functions to create physics objects
    func createPhysicsObjects(){
        createDynamicBodies();
        createStaticBodies();
    }
    
    //creates the camera
    func createCamera(){
        
        cameraNode = SKCameraNode()
        cameraNode.setScale(1)
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.camera = cameraNode
        self.addChild(cameraNode)
        
    }
    
    //create the background nodes
    func createBackground(){
        
        back1 = SKSpriteNode(imageNamed: backgrounds[index])
        back1.zPosition = -1
        back1.name = "back1"
        back1.size = self.frame.size
        back1.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(back1)
        
        back2 = SKSpriteNode(imageNamed: backgrounds[index])
        back2.zPosition = -1
        back1.name = "back2"
        back2.size = self.frame.size
        back2.position = CGPoint(x: self.frame.maxX + 450, y: frame.midY)
        self.addChild(back2)
        
    }
    
    //create the animation and make it play forever
    func createAction(){
        
        let skAtlas = SKTextureAtlas(named: "bird")
        flyAction = SKAction.animate(with: [skAtlas.textureNamed("1"),
                                            skAtlas.textureNamed("2"),
                                            skAtlas.textureNamed("3"),
                                            skAtlas.textureNamed("4"),
                                            skAtlas.textureNamed("5")], timePerFrame: 0.1)
        
        moveAction = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: 600), duration: 1))
        
    }
    
    //create the player nodes and physics
    func createPlayer(){
        
        //create the player node
        player = SKSpriteNode()
        player.name = "red"
        player.size = CGSize(width : 64, height : 64)
        player.position = CGPoint(x: frame.midX, y: frame.midY)
        
        //make it play the animation
        player.run(SKAction.repeatForever(flyAction), withKey: "fly")
        
        //physics for the player body
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.frame.width/2)
        player.physicsBody?.categoryBitMask = CategoryBitMask.redNode
        player.physicsBody?.collisionBitMask = CategoryBitMask.blueNode | CategoryBitMask.obstacle
        player.physicsBody?.contactTestBitMask = CategoryBitMask.blueNode | CategoryBitMask.obstacle
        
        player.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 200, dy: 0), duration: 1)))
        
        //add the player to the scene
        self.addChild(player)
        
    }
    
    //creates a body that moves with physics based movement
    func createDynamicBodies(){

        //create a blue circle with physics
        blueNode = SKSpriteNode(imageNamed: "star")
        blueNode.name = "blue"
        blueNode.size = CGSize(width: 50, height: 50)
        blueNode.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        blueNode.physicsBody = SKPhysicsBody(circleOfRadius: blueNode.frame.width/2)
        blueNode.physicsBody?.categoryBitMask = CategoryBitMask.blueNode
        addChild(blueNode)
    
    }
    
    //create a physics body that doesn't move but does collide
    func createStaticBodies(){
        
        //create a floor
        rectangle = SKSpriteNode()
        rectangle.color = UIColor.green
        rectangle.size = CGSize(width: self.frame.width * 10, height: 10)
        rectangle.name = "obstacle"
        rectangle.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.midY/4)
        rectangle.physicsBody = SKPhysicsBody(rectangleOf: rectangle.size)
        rectangle.physicsBody?.isDynamic = false
        rectangle.physicsBody?.categoryBitMask = CategoryBitMask.obstacle
        self.addChild(rectangle)
        
        killFloor = SKSpriteNode();
        killFloor.color = UIColor.red
        killFloor.size = CGSize(width: self.frame.width * 10, height: 10)
        killFloor.name = "killFloor"
        killFloor.position = CGPoint(x: self.frame.midX, y: self.frame.midY - self.frame.midY/2)
        killFloor.physicsBody = SKPhysicsBody(rectangleOf: killFloor.size)
        killFloor.physicsBody?.isDynamic = false
        killFloor.physicsBody?.categoryBitMask = CategoryBitMask.blueNode
        self.addChild(killFloor)
        
    }
    
    //collision start
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == CategoryBitMask.redNode | CategoryBitMask.blueNode){
            print("Collision")
            playerLose = true
        }
        
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == CategoryBitMask.redNode | CategoryBitMask.obstacle){
           print("contact between \(contact.bodyA.node?.name ?? "no name") and \(contact.bodyB.node?.name ?? "No Name")")
        }
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == CategoryBitMask.blueNode | CategoryBitMask.obstacle){
            print("contact between \(contact.bodyA.node?.name ?? "no name") and \(contact.bodyB.node?.name ?? "No Name")")
        }
    }
    
    //collision end
    func didEnd(_ contact: SKPhysicsContact) {
        
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == CategoryBitMask.redNode | CategoryBitMask.obstacle){
            print("End contact between \(contact.bodyA.node?.name ?? "no name") and \(contact.bodyB.node?.name ?? "No Name")")
        }
        if(contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == CategoryBitMask.blueNode | CategoryBitMask.obstacle){
            print("End contact between \(contact.bodyA.node?.name ?? "no name") and \(contact.bodyB.node?.name ?? "No Name")")
        }
        
    }
    

    //when the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        
        //quit button functionality
        if(quitlabel.contains(location!)){
            let newScene = MainMenu(size:(self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 2)
            self.view?.presentScene(newScene, transition: transition)
            transition.pausesOutgoingScene = true
            transition.pausesIncomingScene = false
        }
        
        //apply the move action
        player.run(moveAction, withKey: "move")
    }
    //when the user stops touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //remove the action
        player.removeAction(forKey: "move")
    }
}



