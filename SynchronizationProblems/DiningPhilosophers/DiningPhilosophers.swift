//
//  DiningPhilosophers.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

let DiningPhilosophersCount = 5

class PhilosopherBlockOperation: NSBlockOperation {
    init(index: Int) {
        super.init()
        addExecutionBlock({
            print("philosopher \(index) is eating")
            sleep(2)
            print("philosopher \(index) puts forks")
        })
    }
}

class DiningPhilosophersOperationScheduler {
    var philosopherQueues = [NSOperationQueue]()
    
    init() {
        // В нашем представлении философы - это серийные очереди
        for _ in 1...DiningPhilosophersCount {
            let philosopherQueue = NSOperationQueue()
            philosopherQueue.maxConcurrentOperationCount = 1
            philosopherQueues.append(philosopherQueue)
        }
    }
    
    func startPhilosopher(index: Int) {
        if (index >= DiningPhilosophersCount) {
            print("No such philosopher")
            return;
        }
        
        let operation = PhilosopherBlockOperation(index: index)
        
        let leftPhilosopherQueue = getLeftPhilosopher(index)
        let rightPhilosopherQueue = getRightPhilosopher(index)
        
        queryPhilosopher(leftPhilosopherQueue, operation: operation)
        queryPhilosopher(rightPhilosopherQueue, operation: operation)
        
        let currentPhilosopherQueue = philosopherQueues[index]
        print("philosopher \(index) is thinking")
        currentPhilosopherQueue.addOperation(operation)
    }
    
    func queryPhilosopher(philosopher: NSOperationQueue, operation: PhilosopherBlockOperation) {
        let philosopherEats = philosopher.operationCount > 0
        
        // Если философ ест, будем ждатьв ыполнения всех его операций
        if philosopherEats {
            for philosopherOperation in philosopher.operations {
                operation.addDependency(philosopherOperation)
            }
        }
    }
    
    func getLeftPhilosopher(index: Int) -> NSOperationQueue {
        let leftIndex = index > 0 ? index - 1 : DiningPhilosophersCount - 1
        return philosopherQueues[leftIndex]
    }
    
    func getRightPhilosopher(index: Int) -> NSOperationQueue {
        let rightIndex = index < DiningPhilosophersCount - 1 ? index + 1 : 0
        return philosopherQueues[rightIndex]
    }
}