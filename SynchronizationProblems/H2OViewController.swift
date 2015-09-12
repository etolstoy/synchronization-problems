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
    override func didMoveToView(view: SKView) {
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if (location.x < self.size.width / 2) {
                let sprite = HydrogenNode.hydrogen(touch.locationInNode(self))
                self.addChild(sprite)
            } else {
                let sprite = PlayerNode.player(touch.locationInNode(self))
                self.addChild(sprite)
            }
            
            
        }
    }
}

class HydrogenNode: SKSpriteNode {
    class func hydrogen(location: CGPoint) -> HydrogenNode {
        let sprite = HydrogenNode(imageNamed: "hydrogen")
        
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

class PlayerNode: SKSpriteNode {
    class func player(location: CGPoint) -> PlayerNode {
        let sprite = PlayerNode(imageNamed:"player")
        
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

class GameScene: SKScene {
    
    let hydrogenBottle = SKSpriteNode(imageNamed: "bottle")
    let oxygenBottle = SKSpriteNode(imageNamed: "bottle")
    let scheduler = H2OOperationScheduler()
    
    var hydrogenCount = 0
    var oxygenCount = 0
    
    let fallingSpeed : CGFloat = 80.0
    
    override func didMoveToView(view: SKView) {

        backgroundColor = SKColor.whiteColor()

        hydrogenBottle.position = CGPoint(x: hydrogenBottle.size.width / 2 + 20, y: self.size.height - hydrogenBottle.size.height / 2 - 150)
        addChild(hydrogenBottle)

        oxygenBottle.position = CGPoint(x: self.size.width - oxygenBottle.size.width / 2 - 20, y: self.size.height - oxygenBottle.size.height / 2 - 150)
        addChild(oxygenBottle)
        
        addChild(oxygenButtonNode())
        addChild(hydrogenButtonNode())
        
//        runAction(SKAction.repeatActionForever(
//            SKAction.sequence([
//                SKAction.runBlock(addOxygen),
//                SKAction.runBlock(addHydrogen),
//                SKAction.waitForDuration(1.0)
//                ])
//            ))
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch: UITouch = touches.first!;
//        let location = touch.locationInNode(self)
//        let node = self.nodeAtPoint(location)
//        
//        if node.name == "oxygenButtonNode" {
//            let oxygen = createOxygen()
//            oxygen.runAction(moveOxygen(), completion: {
//                self.scheduler.addOxygen({ () -> () in
//                    oxygen.removeFromParent()
//                    self.oxygenCount--
//                })
//            })
//        }
//        
//        if node.name == "hydrogenButtonNode" {
//            let hydrogen = createHydrogen()
//            hydrogen.runAction(moveHydrogen(), completion: {
//                self.scheduler.addHydrogen({ () -> () in
//                    hydrogen.removeFromParent()
//                    self.hydrogenCount--
//                })
//            })
//        }
//    }
    
    func createOxygen() -> SKSpriteNode {
        let oxygen = SKSpriteNode(imageNamed: "oxygen")
        oxygen.position = CGPoint(x: oxygenBottle.position.x, y: self.size.height)
        addChild(oxygen)
        
        return oxygen;
    }
    
    func moveOxygen() -> SKAction {
        let targetY = self.size.height - oxygenBottle.size.height - 120 + 60 * CGFloat(oxygenCount)
        let distance = self.size.height - targetY
        let fallingTime = NSTimeInterval(distance / fallingSpeed)
        
        let actionMove = SKAction.moveToY(targetY, duration: fallingTime)
        
        oxygenCount++
        
        return actionMove;
    }
    
    func createHydrogen() -> SKSpriteNode {
        let hydrogen = SKSpriteNode(imageNamed: "hydrogen")
        hydrogen.position = CGPoint(x: hydrogenBottle.position.x, y: self.size.height)
        addChild(hydrogen)
        
        return hydrogen
    }
    
    func moveHydrogen() -> SKAction {
        let targetY = self.size.height - hydrogenBottle.size.height - 120 + 60 * CGFloat(hydrogenCount)
        let distance = self.size.height - targetY
        let fallingTime = NSTimeInterval(distance / fallingSpeed)
        
        let actionMove = SKAction.moveToY(targetY, duration: fallingTime)

        hydrogenCount++
        return actionMove
    }

    func oxygenButtonNode() -> SKSpriteNode {
        let fireNode = SKSpriteNode(imageNamed: "player")
        
        fireNode.position = CGPointMake(oxygenBottle.position.x, 30);
        fireNode.name = "oxygenButtonNode";
        fireNode.zPosition = 1.0;
        
        return fireNode;
    }
    
    func hydrogenButtonNode() -> SKSpriteNode {
        let fireNode = SKSpriteNode(imageNamed: "player")
        
        fireNode.position = CGPointMake(hydrogenBottle.position.x, 30);
        fireNode.name = "hydrogenButtonNode";
        fireNode.zPosition = 1.0;
        
        return fireNode;
    }
}