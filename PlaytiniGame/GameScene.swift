import GameplayKit
import AudioToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var gameView: GameView!
    private var gameModel = GameModel()

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMove(to view: SKView) {
        backgroundColor = .white
        physicsWorld.contactDelegate = self

        gameView = GameView(scene: self)
        gameView.setup()
        startObstacleGeneration()
    }

    func startObstacleGeneration() {
        let addObstacleAction = SKAction.run {
            if Bool.random() {
                self.addObstacleAbove()
            } else {
                self.addObstacleBelow()
            }
        }
        let waitAction = SKAction.wait(forDuration: CGFloat.random(in: 2.0...4.0))
        let sequenceAction = SKAction.sequence([waitAction, addObstacleAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction, withKey: "obstacleGeneration")
    }

    func stopObstacleGeneration() {
        removeAction(forKey: "obstacleGeneration")
    }

    func addObstacleAbove() {
        let randomOffset = CGFloat.random(in: 10...30)
        let newYPosition = frame.midY + 100 + randomOffset
        addObstacle(yPosition: newYPosition)
    }

    func addObstacleBelow() {
        let randomOffset = CGFloat.random(in: 5...20)
        let newYPosition = frame.midY - 100 - randomOffset
        addObstacle(yPosition: newYPosition)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                switch name {
                case "plus":
                    let newScale = min(gameView.circle.xScale + 0.5, 3.0)
                    let scaleAction = SKAction.scale(to: newScale, duration: 0.2)
                    gameView.circle.run(scaleAction)
                case "minus":
                    let newScale = max(gameView.circle.xScale - 0.5, 1.0)
                    let scaleAction = SKAction.scale(to: newScale, duration: 0.2)
                    gameView.circle.run(scaleAction)
                default:
                    break
                }
            }
        }
    }

    func addObstacle(yPosition: CGFloat) {
        let minWidth: CGFloat = 50
        let maxWidth: CGFloat = 100
        let randomWidth = CGFloat.random(in: minWidth...maxWidth)

        let obstacle = SKSpriteNode(color: .black, size: CGSize(width: randomWidth, height: 10))
        obstacle.position = CGPoint(x: frame.maxX + randomWidth / 2, y: yPosition)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.name = "obstacle"

        addChild(obstacle)

        let moveAction = SKAction.moveBy(x: -frame.width - randomWidth, y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()

        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            gameModel.incrementCollision()
            vibrateDevice()
            
            if let circlePosition = gameView.circle?.position {
                print("Зіткнення! Кількість зіткнень: \(gameModel.collisionCount), Позиція кола: \(circlePosition)")
            }
            
            if gameModel.isGameOver() {
                showAlert()
            }
        }
    }

    func vibrateDevice() {
        print("Vibration")
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func showAlert() {
        isPaused = true

        guard let viewController = self.view?.window?.rootViewController else { return }
        let alert = UIAlertController(title: "Увага!", message: "Ви зіткнулися з перешкодами 5 разів. Перезапустіть гру.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            self.restartGame()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }

    func restartGame() {
        gameModel.reset()
        stopObstacleGeneration()
        removeAllChildren()

        gameView.setup()
        startObstacleGeneration()

        isPaused = false
    }

    override func update(_ currentTime: TimeInterval) {
        gameView.updateCirclePosition()
    }
}


