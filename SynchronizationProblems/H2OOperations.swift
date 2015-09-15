//
//  H2OOperations.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 12/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation
import SpriteKit

class H2OOperation: NSOperation {
    let atomQueue = NSOperationQueue()
    var block: (Array<SKSpriteNode>) -> Void
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
        self.block = block
        super.init()
    }
    
    override var ready: Bool {
        return hydrogen == 2 && oxygen == 1
    }
    
    override func main() {
        atomQueue.suspended = false
        atomQueue.waitUntilAllOperationsAreFinished()
        self.block(nodes)
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

class AtomOperation: NSBlockOperation {
    let node: SKSpriteNode
    init(node: SKSpriteNode, block: () -> Void) {
        self.node = node;
        super.init()
        addExecutionBlock(block)
    }
}