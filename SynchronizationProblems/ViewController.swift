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
    
    }
    
    func diningPhilosophers() {
        let scheduler = DiningPhilosophersOperationScheduler()
        
        scheduler.startPhilosopher(0)
        scheduler.startPhilosopher(3)
        scheduler.startPhilosopher(2)
        scheduler.startPhilosopher(1)
        scheduler.startPhilosopher(4)
    }

    func readersWriters() {
        let scheduler = ReaderWriterOperationScheduler()
        
        scheduler.addWriter()
        for i in 1...5 {
            scheduler.addReader(i)
        }
        scheduler.addWriter()
    }
}