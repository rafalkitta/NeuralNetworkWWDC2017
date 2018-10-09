import Foundation


/// Neural network training data structure
public struct TrainingData {
    
    /// Input training data vector
    public var vectorIn: [Double] = []
    
    /// Output training data vector
    public var vectorOut: [Double] = []
    
    
    /// Default initializer
    ///
    /// - Parameters:
    ///   - vectorIn: Input values
    ///   - vectorOut: Output values
    public init(vectorIn: [Double], vectorOut: [Double]) {
        self.vectorIn = vectorIn
        self.vectorOut = vectorOut
    }
}


/// Normalized data set for Learning/sleeping example
public let normalizedTrainingDataSet1: [TrainingData] = [
    // in: [sleeping, learning], out: [exam score]
    TrainingData(vectorIn: [0.3, 1.0], vectorOut: [0.75]),
    TrainingData(vectorIn: [0.5, 0.2], vectorOut: [0.82]),
    TrainingData(vectorIn: [1.0, 0.4], vectorOut: [0.93]),
    TrainingData(vectorIn: [0.1, 0.89], vectorOut: [0.05]),
    TrainingData(vectorIn: [0.14, 0.73], vectorOut: [0.22]),
    TrainingData(vectorIn: [0.21, 0.85], vectorOut: [0.13]),
    TrainingData(vectorIn: [0.05, 1.0], vectorOut: [0.15]),
    TrainingData(vectorIn: [0.34, 0.86], vectorOut: [0.45]),
    TrainingData(vectorIn: [0.69, 0.4], vectorOut: [0.70]),
    TrainingData(vectorIn: [0.87, 0.1], vectorOut: [0.88]),
    TrainingData(vectorIn: [0.75, 0.2], vectorOut: [0.96]),
    TrainingData(vectorIn: [0.5, 0.05], vectorOut: [0.15]),
    TrainingData(vectorIn: [0.8, 0.45], vectorOut: [0.92]),
    TrainingData(vectorIn: [0.96, 0.09], vectorOut: [0.53]),
    TrainingData(vectorIn: [0.2, 0.32], vectorOut: [0.38]),
    TrainingData(vectorIn: [0.11, 0.79], vectorOut: [0.22]),
    TrainingData(vectorIn: [0.61, 0.85], vectorOut: [0.93]),
    TrainingData(vectorIn: [0.65, 0.68], vectorOut: [0.88]),
    TrainingData(vectorIn: [0.24, 0.16], vectorOut: [0.33]),
    TrainingData(vectorIn: [0.94, 0.16], vectorOut: [0.23]),
    TrainingData(vectorIn: [0.69, 0.4], vectorOut: [0.84]),
    TrainingData(vectorIn: [0.87, 0.19], vectorOut: [0.78]),
    TrainingData(vectorIn: [0.74, 0.28], vectorOut: [0.96]),
    TrainingData(vectorIn: [0.95, 0.3], vectorOut: [0.83])
]
