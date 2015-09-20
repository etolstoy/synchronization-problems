//
//  ReadersWriters.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 28/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import Foundation

class ReaderWriterOperationScheduler {
    let readerQueue = NSOperationQueue()
    let writerQueue = NSOperationQueue()
    let MAX = NSOperationQueueDefaultMaxConcurrentOperationCount
    
    init () {
        // Все читатели должны выполняться параллельно
        readerQueue.maxConcurrentOperationCount = MAX
        
        // Все писатели должны выполняться последовательно
        writerQueue.maxConcurrentOperationCount = 1
    }
    
    func addReaderOperation(operation: NSBlockOperation) {
        // Каждый новый читатель должен дождаться выполнения всех писателей
        // С остальными читателями он выполняется параллельно
        for writerOperation in writerQueue.operations {
            operation.addDependency(writerOperation)
        }
        readerQueue.addOperation(operation)
    }
    
    func addWriterOperation(operation: NSBlockOperation) {
        // Последовательность выполнения писателей обеспечивается самой очередь
        // Всем существующим читателям добавляется зависимость на нового писателя
        for readerOperation in readerQueue.operations {
            readerOperation.addDependency(operation)
        }
        writerQueue.addOperation(operation)
    }
    
    //  Набор вспомогательных методов для демонстрации работы Scheduler'а
    func addReader(index: Int) {
        let operation = NSBlockOperation.init(block: {
            // Для большей убедительности заставим операции выполняться подольше
            sleep(1)
            print("reader \(index) fired")
        })
        addReaderOperation(operation)
    }
    
    func addWriter() {
        let operation = NSBlockOperation.init(block: {
            // Даем писателю больше времени на выполнение, чтобы убедиться в правильности расстановки приоритетов
            sleep(2)
            print("writer fired")
        })
        addWriterOperation(operation)
    }
}