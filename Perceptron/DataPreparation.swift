import Foundation
import UIKit

class DataPreparation {

    enum CoordOrganization {
        case pair,seq
    }

    var values = [Double]()
    var org:CoordOrganization

    init(array:[Double],org:CoordOrganization = .pair){
        self.values = array
        self.org = org
    }

    init(array:[CGPoint],org:CoordOrganization = .pair) {
        // TO DO erreur si != de pair
        if org != .pair {
            print("/.pair/ Coming soon...")
        }
        self.org = org
        self.values = convert(coords:array, org:self.org)

    }
}

extension DataPreparation {
    // mean
    func calcArrayMean() -> [Double] {

        var sums:[Double] = [0.0,0.0]

        for i in 0..<self.values.count {
            sums[i % 2] += self.values[i]
        }

        var meanArray = sums.map{
            $0 / (Double(self.values.count) / 2.0)
        }
        return meanArray
    }

}

extension DataPreparation {
    // normalize
    private func convert(coords:[CGPoint], org:CoordOrganization) -> [Double] {

        var values = [Double]()

        switch org {
            case .pair:
                values = getCGPointToDoubleCouple(pos:coords)
            case .seq:
                values = getCGPointToDouble(pos:coords)
            default:
                fatalError("Unsupported")
        }

        return values
    }

    func normalize() -> [Double] {
        let min = self.values.min()!
        let max = self.values.max()!

        var finalArray = [Double]()

        if min == max {
            for item in values {
                finalArray.append(1.0 / Double(self.values.count))
            }
        }else{
            finalArray = self.values.map{($0 - min)/(max - min)}
        }

        return finalArray
    }

    func formatArray(n:Int) -> [Double]{
        var finalArray = [Double]()

        for i in 0..<n{
            if i < self.values.count {
                finalArray.append(self.values[i])
            }
            else{
                finalArray.append(0.0)
            }
        }

        return finalArray
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

    private func getCGPointToDoubleCouple(pos:[CGPoint]) -> [Double] {
        var values = [Double]()
        
        var t = pos.map{[Double($0.x),Double($0.y)]}
        values = t.flatMap{$0}

        return values
    }

    // standardisation
     func standardization() -> [Double] {
        var means:[Double] = self.calcArrayMean()
        var standardDeviations:[Double] = self.calcStandardDeviation(means:means)

        var standardizedArray = self.values.enumerated().map{
            ($0.element - means[$0.offset % 2] ) / standardDeviations[$0.offset % 2]
        }
        
        return standardizedArray
    }

    private func calcStandardDeviation(means:[Double]) -> [Double]{

        var sums:[Double] = [0.0,0.0]
        var deviations = [Double]()

        for i in 0..<self.values.count {
            sums[i % 2] += pow(self.values[i] - means[i % 2], 2.0)
        }

        deviations = sums.map{
            sqrt($0 / (Double(self.values.count) / 2.0))
        }
        
        return deviations
    }
}
