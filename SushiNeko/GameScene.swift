//
//  GameScene.swift
//  SushiNeko
//
//  Created by Sarin Swift on 10/2/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//
import SpriteKit


enum Side {
    case left, right, none
}

class GameScene: SKScene {
    var sushiBasePiece: SushiPiece!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // connecting the game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        sushiBasePiece.connectChopsticks()
    }
    
}

