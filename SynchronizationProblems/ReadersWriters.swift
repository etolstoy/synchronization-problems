//
//  ReadersWriters.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 28/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

class ReaderWriterBlockOperation: NSBlockOperation {
    var isWriter: Bool
    
    init(block: () -> Void, writer: Bool) {
        isWriter = writer
        
        super.init()
        addExecutionBlock(block)
    }
}

class ReaderWriterOperationScheduler {
    var readerQueue = NSOperationQueue()
    var writerQueue = NSOperationQueue()
    let MAX = NSOperationQueueDefaultMaxConcurrentOperationCount
    
    init () {
        // Все читатели должны выполняться параллельно
        readerQueue.maxConcurrentOperationCount = MAX
        
        // Все писатели должны выполняться последовательно
        writerQueue.maxConcurrentOperationCount = 1
    }
    
    func addReaderOperation (index: Int) {
        let readerOperation = ReaderWriterBlockOperation.init(block: {
                // Для большей убедительности заставим операции выполняться подольше
                sleep(1)
                print("reader \(index) fired")
            }, writer: false)
        readerOperation.isWriter = false
        addOperation(readerOperation)
    }
    
    func addWriterOperation () {
        let writerOperation = ReaderWriterBlockOperation.init(block: {
            // Даем писателю больше времени на выполнение, чтобы убедиться в правильности расстановки приоритетов
            sleep(2)
            print("writer fired")
        }, writer: true)
        writerOperation.isWriter = true
        addOperation(writerOperation)
    }
    
    func addOperation(operation: ReaderWriterBlockOperation) {
        let isReader = !operation.isWriter
        let hasWriters = writerQueue.operationCount > 0
        
        let queue = isReader ? readerQueue : writerQueue
        
        if (isReader && hasWriters) {
            // Если мы добавляем читателя, а в очереди уже есть писатели, тогда новый читатель должен дождаться окончания их выполнения
            for writerOperation in writerQueue.operations {
                operation.addDependency(writerOperation)
            }
        }
        
        if (!isReader) {
            // Если мы добавляем писателя, а в очереди были читатели - они должны дождаться его выполнения
            for readerOperation in readerQueue.operations {
                readerOperation.addDependency(operation)
            }
        }
        
        queue.addOperation(operation)
    }
}