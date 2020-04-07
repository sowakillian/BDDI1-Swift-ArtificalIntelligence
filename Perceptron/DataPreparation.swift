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
        var sumX:Double = 0
        var sumY:Double = 0

        var meanArray = [Double]()

        for i in 0..<self.values.count {
            if i % 2 == 0{
                sumX += self.values[i]
            }
            else{
                sumY += self.values[i]
            }
        }
        meanArray.append(sumX / (Double(self.values.count) / 2.0))
        meanArray.append(sumY / ( Double(self.values.count) / 2.0))

        return meanArray
    }

    // standardisation
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

        var standardizedArray = [Double]()
        for i in 0..<self.values.count{
            var standardizedValue:Double = 0
            if i % 2 == 0{
                standardizedValue = (self.values[i] - means[0] ) / standardDeviations[0]
            }
            else{
                standardizedValue = (self.values[i] - means[1] ) / standardDeviations[1]
            }
            standardizedArray.append(standardizedValue)
        }
        return standardizedArray
    }

    private func calcStandardDeviation(means:[Double]) -> [Double]{

        var sumX:Double = 0
        var sumY:Double = 0

        var deviations = [Double]()

        for i in 0..<self.values.count {
            if i % 2 == 0{
                sumX += pow(self.values[i] - means[0], 2.0)
            }
            else{
                sumY += pow(self.values[i] - means[1], 2.0)
            }
        }
        var xDeviation:Double  = sqrt(sumX / (Double(self.values.count) / 2.0))
        var yDeviation:Double  = sqrt(sumY / (Double(self.values.count) / 2.0))

        deviations.append(xDeviation)
        deviations.append(yDeviation)

        return deviations
        
    }
}
