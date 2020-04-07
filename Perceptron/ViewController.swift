//
//  ViewController.swift
//  Perceptron
//
//  Created by SOWA KILLIAN on 06/04/2020.
//  Copyright © 2020 SOWA KILLIAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let perceptron = Perceptron(nbInput:3)
        
        print(perceptron.predict(nbInput: [1.0, 0.3, 4.0]))
        print(perceptron.predict(nbInput: [1.0, 0.3,4.0]))
        
        let dataSet = [([1.0, 0.3,4.0],0.0), ([0.0, 0.5,1.0],1.0)]
        perceptron.train(dataSet: dataSet, epoch: 6, lr: 0.01)
        
        print(perceptron.predict(nbInput: [1.0, 0.3,4.0]))
        print(perceptron.predict(nbInput: [1.0, 0.3,4.0]))
    }

}

