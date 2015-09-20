//
//  BuildingH2O.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

class H2OOperationScheduler {
    let barrierQueue = NSOperationQueue()
    
    // Этот блок вызывается при успешном сборе молекулы H2O,
    // задается снаружи
    var moleculeBlock: (Array<SKSpriteNode>) -> Void
    
    init(H2OBlock: (Array<SKSpriteNode>) -> Void) {
        // По условию задачи операции-барьеры должны выполняться последовательно
        barrierQueue.maxConcurrentOperationCount = 1
        moleculeBlock = H2OBlock
    }
    
    func addOxygen(node: SKSpriteNode, block: () -> Void) {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.oxygen < 1
        }
        let operation = AtomOperation(node: node, block: block)
        currentBarrier.addOxygen(operation)
    }
    
    func addHydrogen(node: SKSpriteNode, block: () -> Void) {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.hydrogen < 2
        }
        let operation = AtomOperation(node: node, block: block)
        currentBarrier.addHydrogen(operation)
    }
    
    // Вкратце - мы обходим очередь барьеров в поисках подходящего, 
    // если не найден - создаем новый и кладем в очередь.
    // "Подходящесть" определяется переданным замыканием.
    func obtainBarrier(condition: (barrier: H2OOperation) -> Bool) -> H2OOperation {
        let currentBarrier: H2OOperation
        if barrierQueue.operationCount > 0 {
            currentBarrier = barrierQueue.operations.first as! H2OOperation
            if (!condition(barrier: currentBarrier)) {
                return obtainNextBarrier(currentBarrier, condition: condition)
            }
            return currentBarrier
        } else {
            return newBarrier()
        }
    }

    func obtainNextBarrier(barrier: H2OOperation, condition: (barrier: H2OOperation) -> Bool) -> H2OOperation {
        let nextIndex = barrierQueue.operations.indexOf(barrier)! + 1
        
        if barrierQueue.operationCount > nextIndex {
            let nextBarrier = barrierQueue.operations[nextIndex] as! H2OOperation
            if (!condition(barrier: nextBarrier)) {
                return obtainNextBarrier(nextBarrier, condition: condition)
            } else {
                return nextBarrier
            }
        } else {
            return newBarrier()
        }
    }

    func newBarrier() -> H2OOperation {
        let newBarrier = H2OOperation(block: moleculeBlock)
        barrierQueue.addOperation(newBarrier)
        return newBarrier
    }
}