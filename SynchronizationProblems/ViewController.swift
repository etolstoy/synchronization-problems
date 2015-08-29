//
//  ViewController.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 24/08/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        buildingH2O()
    }
    
    func buildingH2O() {
        let sheduler = H2OOperationSheduler()
        
        for _ in 1...10 {
            sheduler.addHydrogen()
        }
        
        for _ in 1...5 {
            sheduler.addOxygen()
        }
    }
    
    func diningPhilosophers() {
        let sheduler = DiningPhilosophersOperationSheduler()
        
        sheduler.startPhilosopher(0)
        sheduler.startPhilosopher(3)
        sheduler.startPhilosopher(2)
        sheduler.startPhilosopher(1)
        sheduler.startPhilosopher(4)
    }

    func readersWriters() {
        let sheduler = ReaderWriterOperationSheduler()
        
        sheduler.addWriterOperation()
        for i in 1...5 {
            sheduler.addReaderOperation(i)
        }
        sheduler.addWriterOperation()
    }
}