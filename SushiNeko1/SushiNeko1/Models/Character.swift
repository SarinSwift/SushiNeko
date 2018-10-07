//
//  Character.swift
//  SushiNeko1
//
//  Created by Sarin Swift on 10/6/18.
//  Copyright © 2018 sarinswift. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    let punch = SKAction(named: "Punch")!
    
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                xScale = -1
                position.x = 252
            }
            run(punch)
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
