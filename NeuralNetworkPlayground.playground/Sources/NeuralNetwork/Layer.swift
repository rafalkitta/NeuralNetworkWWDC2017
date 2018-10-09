import Foundation


/// Neural network layer structure
public struct Layer {
    
    /// Neuron
    public var neuron: Neuron
    
    /// Values vector with values count equal to neuron culumns number
    ///
    /// - Note: Defaultly initialized with values: 0.0
    public lazy var values: [Double] = [Double](repeating: Double(), count: self.neuron.columns)
    
    
    /// Defult initializer
    ///
    /// - parameter neuron: `Neuron` instance
    ///
    /// - returns: `Layer` instance
    public init(neuron: Neuron) {
        // Store neuron
        self.neuron = neuron
        // Randomize neuron values with range -5...5
        self.neuron.randomizeMatrix()
    }
}


// MARK: - CustomStringConvertible
extension Layer: CustomStringConvertible {
    
    /// Structure instance description format
    public var description: String {
        return "\(neuron)"
    }
}

