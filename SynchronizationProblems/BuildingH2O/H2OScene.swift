//
//  H2OScene.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 20/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

// Класс сцены, в которой и происходят события объединения атомов в молекулы
class H2OScene: SKScene {
    
    let scheduler = H2OOperationScheduler { (nodes) -> Void in }
    
    override func didMoveToView(view: SKView) {
        
        // Задаем блок, который будет выполняться для каждой собранной молекулы
        scheduler.moleculeBlock = { (nodes) -> Void in
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            for node in nodes {
                node.runAction(SKAction.sequence([
                    // Собираем все атомы в центре емкости
                    SKAction.moveTo(CGPoint(x: width / 2, y: node.position.y), duration: 1.0),
                    // Поднимаем все атомы на определенную высоту
                    SKAction.moveTo(CGPoint(x: width / 2, y: height - 200), duration: 1.0),
                    // Уводим молекулу за правый край экрана
                    SKAction.moveTo(CGPoint(x: width * 2, y: height / 2), duration: 2.0),
                    ]))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (location.x < self.size.width / 2) {
                triggerHydrogenEvent(location)
            } else {
                triggerOxygenEvent(location)
            }
        }
    }
    
    func triggerHydrogenEvent(location: CGPoint) {
        let sprite = AtomNode.atom("hydrogen", location: location)
        self.addChild(sprite)
        
        self.scheduler.addHydrogen(sprite, block: atomExecutionBlock(sprite))
    }
    
    func triggerOxygenEvent(location: CGPoint) {
        let sprite = AtomNode.atom("oxygen", location: location)
        self.addChild(sprite)
        
        self.scheduler.addOxygen(sprite, block: atomExecutionBlock(sprite))
    }
    
    // Действие, которое выполняется для каждого готового атома
    func atomExecutionBlock(sprite: SKSpriteNode) -> () -> Void {
        return {
            sleep(3)
            sprite.runAction(SKAction.scaleBy(1.5, duration: 1.5))
            sleep(2)
        }
    }
}