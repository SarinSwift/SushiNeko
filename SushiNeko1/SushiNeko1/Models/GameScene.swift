//
//  GameScene.swift
//  SushiNeko1
//
//  Created by Sarin Swift on 10/6/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import SpriteKit

enum Side {
    case left, right, none
}

enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var state: GameState = .title
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var health: CGFloat = 1.0 {
        didSet {
            if health > 1.0 { health = 1.0}
            healthBar.xScale = health
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        sushiBasePiece.connectChopsticks()
        
        character = childNode(withName: "character") as! Character
        playButton = childNode(withName: "playButton") as! MSButtonNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        playButton.selectedHandler = {
            self.state = .ready
        }
        
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .gameOver || state == .title { return }
        if state == .ready { state = .playing }
        health += 0.1
        score += 1
        
        // need a single touch here
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        
        if let firstPiece = sushiTower.first as SushiPiece? {
            if character.side == firstPiece.side {
                gameOver()
                return
            }
                
            sushiTower.removeFirst()
            firstPiece.flip(character.side)
            addRandomPieces(total: 1)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        if state != .playing { return }
        
        health -= 0.01
        if health < 0 {
            gameOver()
        }
    }
    
    func addTowerPiece(side: Side) {
        // copying the original sushiPiece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // Accessing last piece properties
        let lastPiece = sushiTower.last
        
        // Add ontop of the last piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        // increment Z to make sure it's on top of the last piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // set the sides
        newPiece.side = side
        
        // add sushi to scene
        addChild(newPiece)
        
        // add sushi piece to the tower
        sushiTower.append(newPiece)
    }
    
    func addRandomPieces(total: Int) {
        for _ in 1...total {
            // access the last piece property
            let lastPiece = sushiTower.last!
            
            // need to make sure we don't create impossible structures
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                // random number generator
                let random = arc4random_uniform(100)
                
                if random < 45 {
                    addTowerPiece(side: .left)
                } else if random < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func gameOver() {
        state = .gameOver
        
        // create turnRed action
        let turnRed = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.50)
        // turn all the sushi piece objects red
        sushiBasePiece.run(turnRed)
        for sushiPiece in sushiTower {
            sushiPiece.run(turnRed)
        }
        // make character turn red
        character.run(turnRed)
        
        // change playButton selection handler
        playButton.selectedHandler = {
            // grab reference to the spriteKit view
            let skView = self.view as SKView?
            
            // load gamescene
            guard let scene = GameScene(fileNamed: "GameScene") as GameScene? else {
                return
            }
            
            // ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            // restart game
            skView?.presentScene(scene)
        }
    }
}
