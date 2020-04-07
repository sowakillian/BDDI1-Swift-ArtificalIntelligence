import Foundation
import UIKit

class DatasetManager {
    static let instance = DatasetManager()
    var dataset:[ ([Double],Double) ] = []

    init() {
    }

    func appendData(data:[Double],expectedResponse:Double)  {
        dataset.append((data,expectedResponse))
    }

    func getData() -> [ ([Double],Double) ] {
        return dataset
    }

    // CGPoint -> [double]
    func toRawDataArray(coord:[CGPoint], nbValues:Int) -> [Double] {
        let data = DataPreparation(array:coord)
        let finalData = DataPreparation(array:data.formatArray(n:nbValues))

        return finalData.formatArray(n:nbValues)
    }

    // CGPoint -> [double] -> normaliser le tableau
    func toNormalizedArray(coord:[CGPoint], nbValues:Int) -> [Double] {
        let data = DataPreparation(array:coord)
        let finalData = DataPreparation(array:data.formatArray(n:nbValues))

        return finalData.normalize()
    }

    // CGPoint -> [double] -> standardiser le tableau
    func toStandardizedArray(coord:[CGPoint], nbValues:Int) -> [Double] {
        let data = DataPreparation(array:coord)
        let finalData = DataPreparation(array:data.formatArray(n:nbValues))

        return finalData.standardization()
    }

    func normalizedDataset(nbValues:Int) -> [ ([Double],Double) ] {
        // Normaliser le dataset
        for i in 0..<dataset.count {
            let data = DataPreparation(array:dataset[i].0)
            let finalData = DataPreparation(array:data.formatArray(n:nbValues))
            dataset[i].0 = finalData.normalize()
        }
        
        return dataset
    }

    func standardizeDataset(nbValues:Int) -> [ ([Double],Double) ] {
        // Standardiser le dataset
        for i in 0..<dataset.count {
            let data = DataPreparation(array:dataset[i].0)
            let finalData = DataPreparation(array:data.formatArray(n:nbValues))
            dataset[i].0 = finalData.standardization()
        }
        
        return dataset
    }

    func clearDataset() {
        dataset = []
    }
}
