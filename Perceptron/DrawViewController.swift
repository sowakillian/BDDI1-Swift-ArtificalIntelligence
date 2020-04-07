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
    
    var circlesImages:[UIImage] = []
    var linesImages:[UIImage] = []
    var correctArray:[UIImage] = []
    let perceptron = Perceptron(nbInput: 60)
    var datasEntryType: String = "row"
    @IBOutlet weak var predictionResult: UILabel!
    
    let datasetManager = DatasetManager()
    
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
        datasetManager.clearDataset()
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
        
        let touchesConverted = datasetManager.toRawDataArray(coord:drawView!.inputTouches, nbValues:60)
        
        if (circleOrLine.selectedSegmentIndex == 0) {
            self.circlesImages.append(image)
            self.correctArray = circlesImages
            datasetManager.appendData(data:touchesConverted,expectedResponse:0)
            
            //appenddata à add ici
        } else if (circleOrLine.selectedSegmentIndex == 1) {
            self.linesImages.append(image)
            self.correctArray = linesImages
            datasetManager.appendData(data:touchesConverted,expectedResponse:1)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func recongizeClicked(_ sender: Any) {
        let touchesConverted = checkDatasType(datasEntryType: datasEntryType, entryTouches: drawView!.inputTouches)

        print(perceptron.predict(nbInput: touchesConverted))
        if (perceptron.predict(nbInput: touchesConverted) == 0.0) {
            print("I'm a crazy circle")
            predictionResult.text = "Circle"
        } else {
            print("I'm a crazy line")
            predictionResult.text = "Line"
        }
    }
    
    @IBAction func trainClicked(_ sender: Any) {
        perceptron.train(dataSet: datasetManager.getData(), epoch: 6, lr: 0.01)
    }
    
    func checkDatasType (datasEntryType: String, entryTouches: [CGPoint]) -> [Double] {
        var dataPrep = datasetManager.toRawDataArray(coord:entryTouches, nbValues:60)
        
        switch datasEntryType {
        case "normalized":
            dataPrep = datasetManager.toNormalizedArray(coord:entryTouches, nbValues:60)
            
        case "standardised":
            dataPrep = datasetManager.toStandardizedArray(coord:entryTouches, nbValues:60)
        default:
            dataPrep = datasetManager.toRawDataArray(coord:entryTouches, nbValues:60)
        }
        
        return dataPrep
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
        return 200
    }

}

