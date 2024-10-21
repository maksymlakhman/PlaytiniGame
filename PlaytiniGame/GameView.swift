import SpriteKit

class GameView {
    private var scene: GameScene
    var circle: SKShapeNode!
    
    //BtnLabel
    var plusButton: SKLabelNode!
    var minusButton: SKLabelNode!
    // BtnImage
//    var plusButton: SKSpriteNode!
//    var minusButton: SKSpriteNode!

    init(scene: GameScene) {
        self.scene = scene
    }

    func setup() {
        scene.backgroundColor = .white
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)

        setupCircle()
        createButtons()
    }

    private func setupCircle() {
        circle = SKShapeNode(circleOfRadius: 100)
        circle.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        circle.fillColor = .accent
        circle.lineWidth = 0

        circle.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        circle.physicsBody?.isDynamic = true
        circle.physicsBody?.categoryBitMask = 1
        circle.physicsBody?.contactTestBitMask = 2
        circle.physicsBody?.collisionBitMask = 0

        scene.addChild(circle)
        addFaceElements()
    }

    private func addFaceElements() {
        let leftEye = SKShapeNode(circleOfRadius: 10)
        leftEye.fillColor = .black
        leftEye.position = CGPoint(x: -40, y: 40)
        circle.addChild(leftEye)

        let rightEye = SKShapeNode(circleOfRadius: 10)
        rightEye.fillColor = .black
        rightEye.position = CGPoint(x: 40, y: 40)
        circle.addChild(rightEye)

        let smilePath = UIBezierPath()
        smilePath.addArc(withCenter: .zero, radius: -30, startAngle: 0, endAngle: .pi, clockwise: true)

        let smile = SKShapeNode(path: smilePath.cgPath)
        smile.strokeColor = .black
        smile.lineWidth = 5
        smile.position = CGPoint(x: 0, y: -20)
        circle.addChild(smile)

        let noseLabel = SKLabelNode(text: "p")
        noseLabel.fontSize = 40
        noseLabel.fontColor = .black
        noseLabel.fontName = "Impact"
        noseLabel.position = CGPoint(x: 0, y: -10)
        circle.addChild(noseLabel)
    }
    
    // Image
//    private func createButtons() {
//        let buttonsX = 0.95
//        let buttonsHeight = -scene.frame.size.height * 0.4
//
//        plusButton = SKSpriteNode(imageNamed: "plus")
//        plusButton.size = CGSize(width: 100, height: 100)
//        plusButton.position = CGPoint(x: buttonsX - 150, y: buttonsHeight)
//        plusButton.name = "plus"
//
//        minusButton = SKSpriteNode(imageNamed: "minus")
//        minusButton.size = CGSize(width: 100, height: 100)
//        minusButton.position = CGPoint(x: buttonsX + 150, y: buttonsHeight)
//        minusButton.name = "minus"
//
//        scene.addChild(plusButton)
//        scene.addChild(minusButton)
//    }

    private func createButtons() {
        let buttonsX = 0.95
        let buttonsHeight = -scene.frame.size.height * 0.4

        plusButton = SKLabelNode(text: "+")
        plusButton.fontSize = 150
        plusButton.fontColor = .accent
        plusButton.position = CGPoint(x: buttonsX - 150, y: buttonsHeight)
        plusButton.name = "plus"

        minusButton = SKLabelNode(text: "-")
        minusButton.fontSize = 200
        minusButton.fontColor = .accent
        minusButton.position = CGPoint(x: buttonsX + 150, y: buttonsHeight)
        minusButton.name = "minus"

        scene.addChild(plusButton)
        scene.addChild(minusButton)
    }

    func updateCirclePosition() {
        circle.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        circle.zRotation -= 0.05
    }
    
}
