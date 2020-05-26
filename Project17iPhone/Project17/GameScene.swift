//
//  GameScene.swift
//  Project17
//
//  Created by test on 24/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var startGameLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    let possibleEnemies: [String] = ["ball","hammer","tv"]
    var isGameOver = true
    var gameTimer: Timer?
    var createdEnemies = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 160, y: 568)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        startGameLabel = SKLabelNode(fontNamed: "Arial")
        startGameLabel.fontSize = 50
        startGameLabel.position = CGPoint(x: 160, y: 280)
        startGameLabel.horizontalAlignmentMode = .center
        startGameLabel.text = "Start"
        addChild(startGameLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        addChild(scoreLabel)
    }
    
    func startGame() {
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: player.size.width*0.75, height: player.size.height*0.75)
        player.zRotation = .pi / 2
        player.position = CGPoint(x: 160, y: 100)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel.fontSize = 20
        scoreLabel.position = CGPoint(x: 100, y: 552)
        scoreLabel.horizontalAlignmentMode = .left
        
        score = 0
        startGameLabel.isHidden = true
        isGameOver = false
        
        for node in children {
            if node.name == "enemy" {
                node.removeFromParent()
            }
        }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(startGameLabel) {
            startGame()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.y < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
                score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { return }
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.x < 20 {
            location.x = 20
        } else if location.x > 300 {
            location.x = 300
        }
        
        player.position = location
     }
    
    @objc func createEnemy() {
        if isGameOver { return }
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.name = "enemy"
        sprite.scale(to: CGSize(width: sprite.size.width*0.75, height: sprite.size.height*0.75))
        sprite.position = CGPoint(x: Int.random(in: 50...280), y: 568)
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: 0, dy: -400)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        createdEnemies += 1
        if createdEnemies > 3 {
            createdEnemies = 0
            
            if let timeInterval = gameTimer?.timeInterval {
                gameTimer?.invalidate()
                gameTimer = Timer.scheduledTimer(timeInterval: timeInterval - 0.1, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isGameOver = true
        
        endTheGame()
    }
    
    func endTheGame() {
        scoreLabel.position = CGPoint(x: 160, y: 280)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.fontSize = 45
        startGameLabel.position = CGPoint(x: 160, y: 240)
        startGameLabel.text = "Play again"
        startGameLabel.horizontalAlignmentMode = .center
        startGameLabel.fontSize = 40
        startGameLabel.fontColor = .systemRed
        startGameLabel.isHidden = false
        gameTimer?.invalidate()
    }
    
}
