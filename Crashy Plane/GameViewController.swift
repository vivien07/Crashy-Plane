import UIKit
import SpriteKit




class GameViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
        
    }

    
    override var shouldAutorotate: Bool {
        return true
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
