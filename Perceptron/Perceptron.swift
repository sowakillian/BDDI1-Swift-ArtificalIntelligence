import Foundation

class Perceptron {

    var weights:[Double]
    var biais:Double = 0.01

    init(nbInput:Int) {
        weights = []
        for _ in 0..<nbInput {
            weights.append(0.0)
        }
    }
    
    func predict(nbInput:[Double]) -> Double {
        var predictResult: Double = 0.0
        for i in 0..<nbInput.count {
            predictResult += nbInput[i]*self.weights[i]
        }
        
        let sumOfProduct = predictResult+self.biais
        
        return activate(param: sumOfProduct)
    }
    
    func train(dataSet:[([Double],Double)], epoch:Int, lr:Double) {
        for _ in 0..<epoch {
            for data in dataSet {
                let dataPredict = self.predict(nbInput: data.0)
                let error = data.1-dataPredict
                var inputByError = [Double]()
                for d in data.0 {
                    inputByError.append(d*error)
                }
                
                for i in 0..<inputByError.count {
                    weights[i] += inputByError[i]*lr
                }
                
                self.biais += error*lr
            }
        }
    }
    
    func activate(param:Double) -> Double {
        if param > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    

}
