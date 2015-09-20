//
//  H2OViewController.swift
//  SynchronizationProblems
//
//  Created by Egor Tolstoy on 06/09/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

import UIKit
import SpriteKit

class H2OViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setupScene() {
        let scene = H2OScene(fileNamed:"H2OLaboratory.sks")
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene!.scaleMode = .AspectFit
        skView.presentScene(scene)
    }
}