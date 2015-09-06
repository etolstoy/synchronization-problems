//
//  BuildingH2O.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

class H2OBarrierBlockOperation: NSBlockOperation {
    var hydrogen = 0
    var oxygen = 0

    init(barrierQueue: NSOperationQueue) {
        super.init()
        
        // Если мы хотим выполнить какую-то работу в результате составления молекулы H2O,
        // то сделать ее можно в этом замыкании
        addExecutionBlock { () -> Void in
            sleep(1)
            print("processing new H2O molecule, oxygen: \(self.oxygen), hydrogen:\(self.hydrogen)")
            self.suspendQueueIfNeeded(barrierQueue)
        }
    }
    
    func suspendQueueIfNeeded(queue: NSOperationQueue) {
        // Если выполнился последний барьер - то останавливаем очередь
        if (queue.operationCount <= 1) {
            queue.suspended = true
            return;
        }
        
        // Если следующий барьер готов выполниться - то не останавливаем очередь
        let nextBarrier = queue.operations[1] as! H2OBarrierBlockOperation
        if (!nextBarrier.isBarrierReady()) {
            queue.suspended = true
        }
    }
    
    func isBarrierReady() -> Bool {
        return hydrogen == 2 && oxygen == 1
    }
}

class H2OOperationScheduler {
    var oxygenQueue = NSOperationQueue()
    var hydrogenQueue = NSOperationQueue()
    var barrierQueue = NSOperationQueue()
    let MAX = NSOperationQueueDefaultMaxConcurrentOperationCount
    
    init() {
        oxygenQueue.maxConcurrentOperationCount = MAX
        hydrogenQueue.maxConcurrentOperationCount = MAX
        // По условию задачи операции-барьеры должны выполняться последовательно
        barrierQueue.maxConcurrentOperationCount = 1
        
        // Чтобы не было ложного срабатывания при добавлении первого барьера, изначально очередь остановлена
        barrierQueue.suspended = true
    }
    
    func addOxygen() {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.oxygen == 1
        }
        
        let oxygenOperation = newOxygenOperation()
        
        oxygenOperation.addDependency(currentBarrier)
        oxygenQueue.addOperation(oxygenOperation)
        
        currentBarrier.oxygen += 1
        
        withdrawBarrierIfNeeded(currentBarrier)
    }
    
    func addHydrogen() {
        let currentBarrier = obtainBarrier { (barrier) -> Bool in
            return barrier.hydrogen == 2
        }

        let hydrogenOperation = newHydrogenOperation()
        
        hydrogenOperation.addDependency(currentBarrier)
        hydrogenQueue.addOperation(hydrogenOperation)
        
        currentBarrier.hydrogen += 1
        
        withdrawBarrierIfNeeded(currentBarrier)
    }
    
    func withdrawBarrierIfNeeded(barrier: H2OBarrierBlockOperation) {
        if (barrier.isBarrierReady()) {
            barrierQueue.suspended = false
        }
    }
    
    // Вкратце - мы обходим очередь барьеров в поисках подходящего, если не найден - создаем новый и пушим в очередь.
    // "Подходящесть" определяется переданным замыканием.
    func obtainBarrier(condition: (barrier: H2OBarrierBlockOperation) -> Bool) -> H2OBarrierBlockOperation {
        let currentBarrier: H2OBarrierBlockOperation
        if (barrierQueue.operationCount > 0) {
            currentBarrier = barrierQueue.operations.first as! H2OBarrierBlockOperation
            if (condition(barrier: currentBarrier)) {
                return obtainNextBarrier(currentBarrier, condition: condition)
            }
            return currentBarrier
        } else {
            return newBarrier()
        }
    }
    
    func obtainNextBarrier(barrier: H2OBarrierBlockOperation, condition: (barrier: H2OBarrierBlockOperation) -> Bool) -> H2OBarrierBlockOperation {
        let nextIndex = barrierQueue.operations.indexOf(barrier)! + 1
        
        if (barrierQueue.operationCount > nextIndex) {
            let nextBarrier = barrierQueue.operations[nextIndex] as! H2OBarrierBlockOperation
            if (condition(barrier: nextBarrier)) {
                return obtainNextBarrier(nextBarrier, condition: condition)
            } else {
                return nextBarrier
            }
        } else {
            return newBarrier()
        }
    }

    func newBarrier() -> H2OBarrierBlockOperation {
        let newBarrier = H2OBarrierBlockOperation(barrierQueue: barrierQueue)
        if (barrierQueue.operationCount > 0) {
            newBarrier.addDependency(barrierQueue.operations.last!)
        }

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