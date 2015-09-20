//
//  H2OOperations.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 12/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

// Операция молекулы H2O. Выполняется строго после выполнения всех операций атомов (H и O).
class H2OOperation: NSOperation {
    // Внутренняя очередь операций атомов, запускается при старте самой операции
    let atomQueue = NSOperationQueue()
    
    // Блок, вызываемый по выполнении всех операций атомов, задает поведение молекулы H2O
    let moleculeBlock: (Array<SKSpriteNode>) -> Void
    
    // Массив всех SKSpriteNode атомов, относящихся к молекуле H2O.
    // Наполняется при добавлении соответствующих операций.
    var nodes = Array<SKSpriteNode>()
    
    var hydrogen = 0 {
        willSet {
            willChangeValueForKey("isReady")
        }
        didSet {
            didChangeValueForKey("isReady")
        }
    }
    
    var oxygen = 0 {
        willSet {
            willChangeValueForKey("isReady")
        }
        didSet {
            didChangeValueForKey("isReady")
        }
    }
    
    init(block: (Array<SKSpriteNode>) -> Void) {
        atomQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        atomQueue.suspended = true
        self.moleculeBlock = block
        
        super.init()
    }
    
    // Переопределение флага ready у операции позволяет автоматически отправить ее
    // на выполнение при достижении пороговых значений водорода и кислорода
    override var ready: Bool {
        return hydrogen == 2 && oxygen == 1
    }
    
    // Логика исполнения H2O следующая - запускается параллельная очередь операций-атомов,
    // текущий поток ждет их выполнения, затем запускается сам блок, определяющий
    // поведение всей молекулы.
    override func main() {
        atomQueue.suspended = false
        atomQueue.waitUntilAllOperationsAreFinished()
        self.moleculeBlock(nodes)
    }
    
    func addHydrogen(operation: AtomOperation) {
        nodes.append(operation.node)
        atomQueue.addOperation(operation)
        
        hydrogen++
    }
    
    func addOxygen(operation: AtomOperation) {
        nodes.append(operation.node)
        atomQueue.addOperation(operation)
        
        oxygen++
    }
}

// Операция одного атома, задает поведение для водорода/кислорода.
// Должна исполниться до того, как начнет выполняться операция H2O.
// Каждая AtomOperation однозначно соотносится с одной из SKSpriteNode на экране
class AtomOperation: NSBlockOperation {
    
    let node: SKSpriteNode
    
    init(node: SKSpriteNode, block: () -> Void) {
        self.node = node;
        
        super.init()
        addExecutionBlock(block)
    }
}