//
//  GameScene.swift
//  Project11
//
//  Created by test on 07/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var availableBallsLabel: SKLabelNode!
    var availableBalls: Int = 5 {
        didSet {
            availableBallsLabel.text = "Balls: \(availableBalls)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        for i in 0..<5 {
            makeBouncer(at: CGPoint(x: i*256, y: 0))
        }
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        availableBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        availableBallsLabel.horizontalAlignmentMode = .right
        availableBallsLabel.text = "Balls: 5"
        availableBallsLabel.position = CGPoint(x: 980, y: 650)
        addChild(availableBallsLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    
                    box.name = "box"
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    
                    addChild(box)
                } else if availableBalls>0 {
                    let ball = SKSpriteNode(imageNamed: generateRandomBallColor())
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = CGPoint(x: location.x, y: 700)
                    ball.name = "ball"
                    addChild(ball)
                    availableBalls -= 1
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        switch object.name {
        case "good":
            destroy(ball: ball)
            score += 1
            availableBalls += 1
        case "bad":
            destroy(ball: ball)
            score -= 1
        case "box":
            destroy(ball: object)
        default:
            return
        }
        
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "SmokePartciles.sks") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    func generateRandomBallColor() -> String {
        let ballFiles: [String] = ["ballBlue","ballGreen","ballCyan","ballGrey","ballPurple","ballRed","ballYellow"]
        return ballFiles.randomElement()!
    }
}
