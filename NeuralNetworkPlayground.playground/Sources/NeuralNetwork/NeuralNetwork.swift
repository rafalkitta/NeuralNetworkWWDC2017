import Foundation


/// Neural network
open class NeuralNetwork {
    
    
    /// Visualisation view of Neural Network. If set, will be informaed about init params of Neural Network, and about adding layers.
    open var visualizationView: NeuralNetworkVisualisationView?
    
    /// Layers array. Settable only via `appendLayer(n: Int)` method
    open var layers: [Layer] = []
    
    /// Input size
    open var sizeIn: Int = 0
    
    /// Output size
    open var sizeOut: Int = 0
    
    
    /// Default initializer
    ///
    /// - parameter sizeIn:  Input size
    /// - parameter sizeOut: Output size
    ///
    /// - returns: `NeuralNetwork` instance
    public init(sizeIn: Int, sizeOut: Int, visualizationView: NeuralNetworkVisualisationView?) {
        // Store sizes
        self.sizeIn = sizeIn
        self.sizeOut = sizeOut
        
        // Append first layer, initially empty - start
        layers.append(Layer(neuron: Neuron(rows: 0, columns: sizeIn)))
        
        // Append last layer -
        layers.append(Layer(neuron: Neuron(rows: sizeIn, columns: sizeOut)))
        
        //
        self.visualizationView = visualizationView
        visualizationView?.inputLayerNeuronNumber = sizeIn
        visualizationView?.outputLayerNeuronNumber = sizeOut
    }
    
    
    /// Appends new layer to `layers` variable. New layer is inserted to pre-last position in `layers` array.
    /// Sets layer's neuronss to appropriate sizes.
    ///
    /// - parameter n: New `Layer` instance
    open func appendLayer(n: Int) {
        var newLayers: [Layer] = []
        var last = 0
        
        // Rewrite all layers except last one
        for i in 0..<(layers.count - 1) {
            newLayers.append(layers[i])
            last = layers[i].neuron.columns
        }
        
        // Insert new layer
        newLayers.append(Layer(neuron: Neuron(rows: last, columns: n)))
        newLayers.append(Layer(neuron: Neuron(rows: n, columns: sizeOut)))
        
        // Store new layers array
        layers = newLayers
        
        //
        visualizationView?.addHiddenLayer(layer: NeuralNetworkLayerView(numberOfNeurons: n))
    }
    
    
    /// Performes propagation on training data.
    ///
    /// - parameter trainingData: Trainig data
    ///
    /// - returns: Result vector of propagation
    open func propagate(trainingData: TrainingData) -> [Double] {
        // Input vector from training data
        var vector: [Double] = trainingData.vectorIn
        
        // Iterate through layers
        for i in 0..<layers.count {
            // Ommit first layer
            guard i != 0 else { continue }
            
            // Multiply
            let matrixA = [vector]
            let matrixB = layers[i].neuron.matrix
            
            // Multiply vector (as one-dimentional matrix) with i-th layer
            let multiplicationResult = multiplyMatrixes(a: matrixA, b: matrixB)
            // Slice first row in result matrix
            vector = multiplicationResult[0]
            
            // Perform activate function
            vector = vector.map { ActivationFunction.sigmoidal(β: -1, x: $0).perform() }
            layers[i].values = vector
        }
        
        return vector
    }
    
    
    /// Calculates error.
    ///
    /// - parameter trainingData: Training data
    ///
    /// - returns: Error vector
    open func calculateError(trainingData: TrainingData) -> [Double] {
        // Output vector from training data
        let y = trainingData.vectorOut
        // Propagation result on traning data
        let ysim = propagate(trainingData: trainingData)
        // Vectors difference
        return zip(y, ysim).map { $0 - $1 }
        
    }
    
    
    /// Performes back propagation on training data.
    ///
    /// - parameter trainingData: Training data
    open func backPropagate(trainingData: TrainingData) {
        // Calculate error
        var error = calculateError(trainingData: trainingData)
        let layersCount = layers.count - 1
        
        // Iterates through layers, except last one
        for i in 0..<layersCount {
            // Performing activation function on layers values matrix
            let activatedValuesMatix = layers[layersCount - i].values.map { ActivationFunction.sigmoidalDeriv(β: -1, x: $0).perform() }
            
            // Vectors multiplication
            let delta = zip(error, activatedValuesMatix).map { $0 * $1 }
            
            let transposedNeuronMatrix = transpose(input: layers[layersCount - i].neuron.matrix)
            error = multiplyMatrixes(a: [delta], b: transposedNeuronMatrix)[0]
            
            let matrix1 = layers[layersCount - i].neuron.matrix
            let matrix2 = multiplyMatrixes2(a: [layers[layersCount - i - 1].values], b: transpose(input: [delta]))
            layers[layersCount - i].neuron.matrix = matrixDifferences(a: matrix1, b: transpose(input: matrix2))
        }
    }
}


// MARK: - Initializers with NeuralNetworkInitParameters
extension NeuralNetwork {
    
    /// Convenience initializer
    /// Allows to initialize `NeuralNetwork` instance with `NeuralNetworkInitParameters` object.
    ///
    /// - Parameter initParameters: All init parameters in single object
    convenience public init(with initParameters: NeuralNetworkInitParameters) {
        // Call more general conveniance initializer
        self.init(with: initParameters, visualizationView: nil)
    }
    
    
    /// Convenience initializer
    /// Allows to initialize `NeuralNetwork` instance with `NeuralNetworkInitParameters` object and `NeuralNetworkVisualisationView`.
    ///
    /// - Parameters:
    ///   - initParameters: All init parameters in single object
    ///   - visualizationView: Visualisation view
    convenience public init(with initParameters: NeuralNetworkInitParameters, visualizationView: NeuralNetworkVisualisationView?) {
        // Call designed initializer
        self.init(sizeIn: initParameters.inputSize, sizeOut: initParameters.outputSize, visualizationView: visualizationView)
        
        // Add hidden layers with given layer's sizes
        for layerSize in initParameters.hiddenLayersSizes {
            self.appendLayer(n: layerSize)
        }
    }
}

// MARK: - CustomStringConvertible
extension NeuralNetwork: CustomStringConvertible {
    
    /// Class instance description format
    open var description: String {
        return "\(layers)"
    }
}


/// Structure contains `NuralNetwork` init parameters, all required to properly create `NeuralNetwork` instance
public struct NeuralNetworkInitParameters {
    
    /// Input layer vector size
    public let inputSize: Int
    
    /// Output layer vector size
    public let outputSize: Int
    
    /// Hidden layers sizes
    public let hiddenLayersSizes: [Int]
    
    
    /// Main initializer
    ///
    /// - Parameters:
    ///   - inputSize: Number of input neurons
    ///   - outputSize: Number of output neurons
    ///   - hiddenLayersSizes: Array with numbers of hidden layers neurons
    public init(inputSize: Int, outputSize: Int, hiddenLayersSizes: [Int]) {
        self.inputSize = inputSize
        self.outputSize = outputSize
        self.hiddenLayersSizes = hiddenLayersSizes
    }
}


// MARK: - Training/reseting
extension NeuralNetwork {
    
    
    /// Reset already trained Neural Network.
    /// Zroes layers values and randomizes matrixes (matrixes of weights).
    open func reset() {
        for index in 0..<layers.count {
            layers[index].values = [Double](repeating: Double(), count: layers[index].neuron.columns)
            layers[index].neuron.randomizeMatrix()
        }
    }
    
    
    /// Trains `Neural Network` with normalized data set. Data set has to be array of `TrainingData` objects. Performs back propagation on each `TrainingData` object as manyy times as in `times` parameter.
    ///
    /// - Parameters:
    ///   - normalizedDataSet: Normalized training data
    ///   - times: Number of training times. Defaultly 500. If big data set, set this falue to 0.
    open func train(with normalizedDataSet: [TrainingData], times: Int = 500) {
        // Train `times` times for smaller data sets
        for _ in 0..<times {
            // perform back propagation for each `TrainingData` instance
            _ = normalizedDataSet.map { backPropagate(trainingData: $0) }
        }
    }
}



