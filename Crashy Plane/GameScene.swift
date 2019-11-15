import SpriteKit


class GameScene: SKScene {
    
    
    var player: SKSpriteNode!
   
    
    override func didMove(to view: SKView) {
        
        createPlayer()
        createSky()
        createBackground()
        createGround()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
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
            addChild(ground)
            //actions
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            ground.run(moveForever)
        }
        
    }
    
    
}
