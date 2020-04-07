//
//  ViewController.swift
//  Perceptron
//
//  Created by SOWA KILLIAN on 06/04/2020.
//  Copyright © 2020 SOWA KILLIAN. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    @IBOutlet weak var circleOrLine: UISegmentedControl!
    @IBOutlet weak var datasType: UISegmentedControl!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnClearDataset: UIButton!
    @IBOutlet weak var btnRecognize: UIButton!
    @IBOutlet weak var drawView: AASignatureView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataset:[([Double], Double)] = []
    var circlesImages:[UIImage] = []
    var linesImages:[UIImage] = []
    var correctArray:[UIImage] = []
    let perceptron = Perceptron(nbInput: 60)
    var datasEntryType: String = "row"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func clearDrawingClicked(_ sender: Any) {
        drawView.clear()
    }
    
    @IBAction func segmentedChanged(_ sender: Any) {
        if (circleOrLine.selectedSegmentIndex == 0) {
            self.correctArray = circlesImages
        } else if (circleOrLine.selectedSegmentIndex == 1) {
            self.correctArray = linesImages
        }
        drawView.clear()
        self.tableView.reloadData()
    }
    
    @IBAction func datasTypeChanged(_ sender: Any) {
        switch datasType.selectedSegmentIndex {
        case 0:
            self.datasEntryType = "row"
        case 1:
            self.datasEntryType = "normalized"
        case 2:
            self.datasEntryType = "standardised"
        default:
            self.datasEntryType = "row"
        }
    }
    

    
    @IBAction func clearDataset(_ sender: Any) {
        self.dataset.removeAll()
        self.circlesImages.removeAll()
        self.linesImages.removeAll()
        self.correctArray.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func addDataset(_ sender: Any) {

        let renderer = UIGraphicsImageRenderer(size: self.drawView.bounds.size)
        let image = renderer.image { ctx in
            drawView.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        let touchesConverted = checkDatasType(datasEntryType: datasEntryType, entryTouches: drawView!.inputTouches)
        
        if (circleOrLine.selectedSegmentIndex == 0) {
            self.circlesImages.append(image)
            self.correctArray = circlesImages
            self.dataset.append((touchesConverted, 0))
        } else if (circleOrLine.selectedSegmentIndex == 1) {
            self.linesImages.append(image)
            self.correctArray = linesImages
            self.dataset.append((touchesConverted, 1))
        }
        
        tableView.reloadData()
    }
    
    @IBAction func recongizeClicked(_ sender: Any) {

        let touchesConverted = checkDatasType(datasEntryType: datasEntryType, entryTouches: drawView!.inputTouches)

        print(perceptron.predict(nbInput: touchesConverted))
        if (perceptron.predict(nbInput: touchesConverted) == 0.0) {
            print("I'm a crazy circle")
        } else {
            print("I'm a crazy line")
        }
    }
    
    @IBAction func trainClicked(_ sender: Any) {
        perceptron.train(dataSet: self.dataset, epoch: 6, lr: 0.01)
    }
    
    func checkDatasType (datasEntryType: String, entryTouches: [CGPoint]) -> [Double] {
        let data = DataPreparation(array:entryTouches)
        let formatedData = data.formatArray(n: 60)
        var dataPrep = DataPreparation(array: formatedData).values
        
        switch datasEntryType {
        case "normalized":
            print("check normalized")
            dataPrep = DataPreparation(array: formatedData).normalize()
            
        case "standardised":
            dataPrep = DataPreparation(array: formatedData).standardization()
            print("check standardized")
        default:
            dataPrep = DataPreparation(array: formatedData).values
        }
        
        print("dataPrep", dataPrep)
        
        return dataPrep
    }
    
    
    private func getCGPointToDouble(pos:[CGPoint]) -> [Double] {
        var values = [Double]()
        
        var coordX = [Double]()
        var coordY = [Double]()

        coordX = pos.map{Double($0.x)}
        coordY = pos.map{Double($0.y)}

        values = coordX + coordY

        return values
    }

    
    
}

extension DrawViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return correctArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.imageView?.image = correctArray[indexPath.row]
  
        return cell
    }
    
    
}

extension DrawViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ToTO \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
