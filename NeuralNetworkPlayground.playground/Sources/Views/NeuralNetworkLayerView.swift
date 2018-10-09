import UIKit


/// View represents Neural Network layer. Contains neurons.
open class NeuralNetworkLayerView: UIView {
    
    
    /// Array with neurons in layer
    var neurons: [NeuronView] = []
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Conveniance initlializer for given neurons number
    ///
    /// - Parameter numberOfNeurons: Number of neurons in layer
    convenience public init(numberOfNeurons: Int) {
        self.init()
        
        // Add neurons
        for _ in 0..<numberOfNeurons {
            addNeuron()
        }
        
        // Set needs layout subviews after add neurons
        setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Distribute vertically
        for (index, nnLayer) in neurons.enumerated() {
            nnLayer.frame = CGRect(
                x: 0.0,
                y: (bounds.height / CGFloat(neurons.count)) * CGFloat(index),
                width: bounds.width,
                height: bounds.height / CGFloat(neurons.count))
        }
    }
    
    
    /// Adds neuron
    open func addNeuron() {
        let newNeuron = NeuronView()
        neurons.append(newNeuron)
        addSubview(newNeuron)
        
        setNeedsLayout()
    }
    
    
    /// Removes last neuron (most bottom one)
    open func removeLastNeuron() {
        _ = neurons.last?.subviews.map { $0.removeFromSuperview() }
        neurons.last?.removeFromSuperview()
        neurons.removeLast()
        
        setNeedsLayout()
    }
}


