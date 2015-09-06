//
//  DiningPhilosophers.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

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
        for _ in 0...4 {
            let philosopherQueue = NSOperationQueue()
            philosopherQueue.maxConcurrentOperationCount = 1
            philosopherQueues.append(philosopherQueue)
        }
    }
    
    func startPhilosopher(index: Int) {
        if (index > 4) {
            print("No such philosopher")
            return;
        }
        
        let operation = PhilosopherBlockOperation(index: index)
        
        let leftPhilosopherQueue = getLeftPhilosopher(index)
        let rightPhilosopherQueue = getRightPhilosopher(index)
        
        let leftPhilosopherEats = leftPhilosopherQueue.operationCount > 0
        let rightPhilosopherEats = rightPhilosopherQueue.operationCount > 0
        
        if (leftPhilosopherEats) {
            for leftOperation in leftPhilosopherQueue.operations {
                operation.addDependency(leftOperation)
            }
        } else {
            print("philosopher \(index) gets left fork")
        }
        
        if (rightPhilosopherEats) {
            for rightOperation in rightPhilosopherQueue.operations {
                operation.addDependency(rightOperation)
            }
        } else {
            print("philosopher \(index) gets right fork")
        }
        
        let currentPhilosopherQueue = philosopherQueues[index]
        print("philosopher \(index) is thinking")
        currentPhilosopherQueue.addOperation(operation)
    }
    
    func getLeftPhilosopher(index: Int) -> NSOperationQueue {
        let leftIndex = index > 0 ? index - 1 : 4
        return philosopherQueues[leftIndex]
    }
    
    func getRightPhilosopher(index: Int) -> NSOperationQueue {
        let rightIndex = index < 4 ? index + 1 : 0
        return philosopherQueues[rightIndex]
    }
}