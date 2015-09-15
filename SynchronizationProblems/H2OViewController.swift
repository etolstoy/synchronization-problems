//
//  H2OViewController.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 06/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import UIKit
import SpriteKit

class H2OViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = H2OScene(fileNamed:"MyScene.sks")

        let skView = view as! SKView
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

class H2OScene: SKScene {

    let scheduler = H2OOperationScheduler { (nodes) -> Void in
    }
    
    override func didMoveToView(view: SKView) {
        scheduler.block = { (nodes) -> Void in
            for node in nodes {
                node.runAction(SKAction.sequence([
                    SKAction.moveTo(CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2), duration: 1.0),
                    SKAction.moveTo(CGPoint(x: self.frame.size.width * 2, y: self.frame.size.height/2), duration: 2.0),
//                    SKAction.fadeOutWithDuration(0)
                    ]))
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (location.x < self.size.width / 2) {
                let sprite = HydrogenNode.hydrogen(touch.locationInNode(self))
                self.addChild(sprite)
                
                let operation = AtomOperation.init(node: sprite, block: {
                    sleep(3)
                    sprite.runAction(SKAction.scaleBy(1.5, duration: 1.5))
                    sleep(2)
                })
                
                self.scheduler.addHydrogen(operation)
            } else {
                let sprite = OxygenNode.player(touch.locationInNode(self))
                self.addChild(sprite)
                
                let operation = AtomOperation.init(node: sprite, block: {
                    sleep(3)
                    sprite.runAction(SKAction.scaleBy(1.5, duration: 1.5))
                    sleep(2)
                })
                self.scheduler.addOxygen(operation)
            }
        }
    }
}
// TODO: Добавляем еще один объект-контейнер, его и будет двигать общая операция.
class HydrogenNode: SKSpriteNode {
    class func hydrogen(location: CGPoint) -> HydrogenNode {
        let sprite = HydrogenNode(imageNamed: "hydrogen")
        
        sprite.xScale = 3
        sprite.yScale = 3
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "player"), size: sprite.size)
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

class OxygenNode: SKSpriteNode {
    class func player(location: CGPoint) -> OxygenNode {
        let sprite = OxygenNode(imageNamed:"oxygen")
        
        sprite.xScale = 3
        sprite.yScale = 3
        sprite.position = location
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "player"), size: sprite.size)
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

class MoleculeNode: SKSpriteNode {
    class func molecule(location: CGPoint) -> MoleculeNode {
        let sprite = MoleculeNode(imageNamed:"molecule")
        
        sprite.xScale = 3
        sprite.yScale = 3
        sprite.position = CGPoint(x: location.x, y: location.y)
        
        sprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "molecule"), size: sprite.size)
        if let physics = sprite.physicsBody {
            physics.affectedByGravity = false
            physics.allowsRotation = false
            physics.dynamic = false;
            physics.linearDamping = 0.75
            physics.angularDamping = 0.75
        }
        
        return sprite
    }
}