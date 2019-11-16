import SpriteKit


class GameScene: SKScene {
    
    
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!

    var score = 0 {
       didSet {
           scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        //game setup
        createSky()
        createBackground()
        createGround()
        createScore()
        createPlayer()
        startRocks()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self //A delegate that is called when two physics bodies come in contact with each other.
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)//makes the game more realistic
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))//gives a push upwards
     
    }
    
    
    func createPlayer() {
        
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        addChild(player)
        //when the action executes, the sprite’s texture property animates through the array of textures
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation) //creates an action that repeats another action forever.
        player.run(runForever)
        //physics
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.isDynamic = true //the physics body is moved by the physics simulation.
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask //whenever the player touches anything the contact is detected
        player.physicsBody!.collisionBitMask = 0
    
        
    }
    
    
    func createSky() {
        
        //topSky
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        topSky.zPosition = -40
        addChild(topSky)
        //bottomSky
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        bottomSky.zPosition = -40
        addChild(bottomSky)
        
    }
    
    
    func createBackground() {
        
        let backgroundTexture = SKTexture(imageNamed: "background")
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)//multiple sprites can share the same texture object, sharing a single resource.
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            background.zPosition = -30
            addChild(background)
            //actions
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            background.run(moveForever)
        }
        
        
    }
    
    
    func createGround() {
        
        let groundTexture = SKTexture(imageNamed: "ground")
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            ground.zPosition = -10
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false//otherwise the ground would drop off
            addChild(ground)
            //actions
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            ground.run(moveForever)
        }
        
    }
    
    
    func createRocks() {
        
        //topRock
        let rockTexture = SKTexture(imageNamed: "rock")
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.zRotation = .pi
        topRock.xScale = -1.0//flip
        topRock.zPosition = -20
        addChild(topRock)
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody!.isDynamic = false
        //bottomRock
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.zPosition = -20
        addChild(bottomRock)
        bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        bottomRock.physicsBody!.isDynamic = false
        //red rectangle:used to track the player's score
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)//creates a rectangular physics body centered on the owning node’s origin.
        rockCollision.physicsBody!.isDynamic = false
        rockCollision.name = "scoreDetect"//to check  for collision
        addChild(rockCollision)
        //positioning
        let xPosition = frame.width + topRock.frame.width
        let max = CGFloat(frame.height / 3)
        let yPosition = CGFloat.random(in: -50...max)
        // this next value affects the width of the gap between rocks
        let rockDistance: CGFloat = 70
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        let endPosition = frame.width + (topRock.frame.width * 2)
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
        
    }
    
    
    func startRocks() {
        
        let create = SKAction.run { [unowned self] in
            self.createRocks()
        }
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
        
    }
    
    
    func createScore() {
        
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        addChild(scoreLabel)
        
    }
   
    
    
}



extension GameScene: SKPhysicsContactDelegate {
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            
            if contact.bodyA.node == player {
                contact.bodyB.node?.removeFromParent()
            } else {
                contact.bodyA.node?.removeFromParent()
            }
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            score += 1
            return
            
        }
        //avoids 2 collisions being triggered at the same time
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else { return }
        //the player hits an obstacle: game over
        if contact.bodyA.node == player || contact.bodyB.node == player {
            
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            player.removeFromParent()
            speed = 0
            
        }
        
    }
    
    
    
}
