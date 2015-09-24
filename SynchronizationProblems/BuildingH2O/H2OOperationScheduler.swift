//
//  BuildingH2O.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

typealias MoleculeBlock = [SKSpriteNode] -> Void
typealias MoleculeCondition = (molecule: H2OOperation) -> Bool

class H2OOperationScheduler {
    let moleculeQueue = NSOperationQueue()
    
    // Этот блок вызывается при успешном сборе молекулы H2O,
    // задается снаружи
    var moleculeBlock: MoleculeBlock
    
    init(H2OBlock: MoleculeBlock) {
        // По условию задачи операции-барьеры должны выполняться последовательно
        moleculeQueue.maxConcurrentOperationCount = 1
        moleculeBlock = H2OBlock
    }
    
    func addOxygen(node: SKSpriteNode, block: () -> Void) {
        let currentMolecule = obtainMolecule { (molecule) -> Bool in
            return molecule.oxygen < 1
        }
        let operation = AtomOperation(node: node, block: block)
        currentMolecule.addOxygen(operation)
    }
    
    func addHydrogen(node: SKSpriteNode, block: () -> Void) {
        let currentMolecule = obtainMolecule { (molecule) -> Bool in
            return molecule.hydrogen < 2
        }
        let operation = AtomOperation(node: node, block: block)
        currentMolecule.addHydrogen(operation)
    }
    
    // Вкратце - мы обходим очередь молекул в поисках подходящей, если не найдена - создаем новую и кладем в очередь.
    // "Подходящесть" определяется переданным замыканием.
    func obtainMolecule(condition: MoleculeCondition) -> H2OOperation {
        let currentMolecule: H2OOperation
        if moleculeQueue.operationCount > 0 {
            currentMolecule = moleculeQueue.operations.first as! H2OOperation
            if (!condition(molecule: currentMolecule)) {
                return obtainNextMolecule(currentMolecule, condition: condition)
            }
            return currentMolecule
        } else {
            return newMolecule()
        }
    }

    func obtainNextMolecule(molecule: H2OOperation, condition: MoleculeCondition) -> H2OOperation {
        let nextIndex = moleculeQueue.operations.indexOf(molecule)! + 1
        
        if moleculeQueue.operationCount > nextIndex {
            let nextMolecule = moleculeQueue.operations[nextIndex] as! H2OOperation
            if (!condition(molecule: nextMolecule)) {
                return obtainNextMolecule(nextMolecule, condition: condition)
            } else {
                return nextMolecule
            }
        } else {
            return newMolecule()
        }
    }

    func newMolecule() -> H2OOperation {
        let newMolecule = H2OOperation(block: moleculeBlock)
        moleculeQueue.addOperation(newMolecule)
        return newMolecule
    }
}