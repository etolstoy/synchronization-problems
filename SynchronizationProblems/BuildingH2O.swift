//
//  BuildingH2O.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

class H2OOperation: NSOperation {
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
    
    override var ready: Bool {
        return hydrogen == 2 && oxygen == 1
    }
    
    override func main() {
        print("H2O")
    }
}

class H2OOperationScheduler {
    let oxygenQueue = NSOperationQueue()
    let hydrogenQueue = NSOperationQueue()
    let barrierQueue = NSOperationQueue()
    let MAX = NSOperationQueueDefaultMaxConcurrentOperationCount
    
    init() {
        oxygenQueue.maxConcurrentOperationCount = MAX
        hydrogenQueue.maxConcurrentOperationCount = MAX
        // По условию задачи операции-барьеры должны выполняться последовательно
        barrierQueue.maxConcurrentOperationCount = 1
    }
    
    func addOxygen() {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.oxygen < 1
        }

        let oxygenOperation = newOxygenOperation()
        
        oxygenOperation.addDependency(currentBarrier)
        oxygenQueue.addOperation(oxygenOperation)
        
        currentBarrier.oxygen += 1
    }
    
    func addHydrogen() {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.hydrogen < 2
        }

        let hydrogenOperation = newHydrogenOperation()
        
        hydrogenOperation.addDependency(currentBarrier)
        hydrogenQueue.addOperation(hydrogenOperation)
        
        currentBarrier.hydrogen += 1
    }
    
    // Вкратце - мы обходим очередь барьеров в поисках подходящего, если не найден - создаем новый и пушим в очередь.
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
        let newBarrier = H2OOperation()
        barrierQueue.addOperation(newBarrier)
        return newBarrier
    }
    
    // Если от операций кислорода и водорода ожидается что-то еще, это можно инкапсулировать в этих функциях
    func newOxygenOperation() -> NSBlockOperation {
        return NSBlockOperation.init(block: {
            print("O")
        })
    }
    
    func newHydrogenOperation() -> NSBlockOperation {
        return NSBlockOperation.init(block: {
            print("H")
        })
    }
}