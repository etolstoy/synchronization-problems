//
//  H2ONodes.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 20/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

enum AtomSprite: String {
    case Hydrogen = "hydrogen"
    case Oxygen = "oxygen"
}

// Класс SKSpriteNode для атомов - как водорода, так и кислорода
class AtomNode: SKSpriteNode {
    class func atom(type: AtomSprite, location: CGPoint) -> AtomNode {
        let sprite = AtomNode(imageNamed: type.rawValue)
        
        sprite.position = location
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: type.rawValue), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = true
            physics.allowsRotation = true
            physics.dynamic = true;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        
        return sprite
    }
}