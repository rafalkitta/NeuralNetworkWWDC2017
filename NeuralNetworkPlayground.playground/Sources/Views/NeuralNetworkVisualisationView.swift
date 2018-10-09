import UIKit


/// Neural Network visualisation view. Contains layers with neurons and connections betweens neurons.
open class NeuralNetworkVisualisationView: UIView {
    
    
    /// Array with layers
    var layers: [NeuralNetworkLayerView] = []
    
    
    /// Number of input neurons
    open var inputLayerNeuronNumber: Int = 1 {
        didSet {
            removeLayer(at: 0)
            addInputLayer()
        }
    }
    
    
    /// Number of output neurons
    open var outputLayerNeuronNumber: Int = 1 {
        didSet {
            removeLayer(at: layers.count - 1)
            addOutputLayer()
        }
    }
    
    
    /// BAckground gradient colors
    var colors = [UIColor(red: 101/255, green: 120/255, blue: 224/255, alpha: 1.0).cgColor,
                  UIColor(red: 24/255, green: 37/255, blue: 109/255, alpha: 1.0).cgColor]
    
    
    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let locations: [CGFloat] = [0.0, 1.0]
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorspace, colors: colors as CFArray, locations: locations)
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        context!.drawRadialGradient (gradient!, startCenter: centerPoint,
                                     startRadius: 0, endCenter: centerPoint, endRadius: frame.width / 2,
                                     options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }

    
    /// Extension of default `UIView` initializer. Gives ability to init view with input and output neurns numbers.
    ///
    /// - Parameters:
    ///   - frame: View frame
    ///   - inputNeurons: Number of input neurons
    ///   - outputNeurons: Number of output neurons
    public init(frame: CGRect, inputNeurons: Int, outputNeurons: Int) {
        super.init(frame: frame)
        
        inputLayerNeuronNumber = inputNeurons
        outputLayerNeuronNumber = outputNeurons
        initialSetup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    
    /// Custom setup
    private func initialSetup() {
        backgroundColor = UIColor(red: 24/255, green: 37/255, blue: 109/255, alpha: 1.0)
        
        // add predefined layers
        addInputLayer()
        addOutputLayer()
        
        setNeedsLayout()
    }
    
    
    /// Adds input layer
    private func addInputLayer() {
        let inputLayer = NeuralNetworkLayerView(numberOfNeurons: inputLayerNeuronNumber)
        layers.insert(inputLayer, at: 0)
        addSubview(inputLayer)
    }
    
    
    /// Adds output layers
    private func addOutputLayer() {
        let outputLayer = NeuralNetworkLayerView(numberOfNeurons: outputLayerNeuronNumber)
        layers.insert(outputLayer, at: layers.count)
        addSubview(outputLayer)
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove all connections
        for lineBetweenNeurons in layer.sublayers! where lineBetweenNeurons is LineShapeLayer {
            lineBetweenNeurons.removeFromSuperlayer()
        }
        
        // Distribute horizonatlly
        for (index, nnLayer) in layers.enumerated() {
            nnLayer.frame = CGRect(
                x: (bounds.width / CGFloat(layers.count)) * CGFloat(index),
                y: 0.0,
                width: bounds.width / CGFloat(layers.count),
                height: bounds.height)
            nnLayer.setNeedsLayout()
            nnLayer.layoutIfNeeded()
        }
        
        // Draw connectins between neurons
        drawAllConnections()
    }
    
    
    /// Draw connections between each neuron with all neurons from next layer
    private func drawAllConnections() {
        // For all layers
        for (index, nnLayer) in layers.enumerated() {
            // For all neurons in layer, except the last one
            for neuron in nnLayer.neurons where layers.count > index + 1 {
                let nextLayersNeurons = layers[index + 1].neurons
                
                // For all neurons from next layer
                for neuronFromNextLayer in nextLayersNeurons {
                    // center of left hand side neuron's body converted to coordinates of `NeuralNetworkVisualisationView`
                    let neuronCenterPoint = neuron.neuronBodyView.center
                    let startPoint = convert(neuronCenterPoint, from: neuron)
                    
                    // center of right hand side neuron's body converted to coordinates of `NeuralNetworkVisualisationView`
                    let neuronFromNextLayerCenterPoint = neuronFromNextLayer.neuronBodyView.center
                    let endPoint = convert(neuronFromNextLayerCenterPoint, from: neuronFromNextLayer)
                    
                    // Draw line between neurons
                    drawLine(from: startPoint, to: endPoint, in: self)
                }
            }
        }
    }
    
    
    /// Add hidden layer
    ///
    /// - Parameter layer: Layer to add
    open func addHiddenLayer(layer: NeuralNetworkLayerView) {
        layers.insert(layer, at: layers.count - 1)
        addSubview(layer)
        
        setNeedsLayout()
    }
    
    
    /// Add hidden layers
    ///
    /// - Parameter layers: Layers to add
    open func addHiddenLayers(layers: [NeuralNetworkLayerView]) {
        _ = layers.map { addHiddenLayer(layer: $0) }
    }
    
    
    /// Remove last hidden layer
    open func removeLastHiddenLayer() {
        removeLayer(at: layers.count - 2)
    }
    
    
    /// Remove layer at given position
    ///
    /// - Parameter index: Index of layer to remove
    open func removeLayer(at index: Int) {
        _  = layers[index].subviews.map { $0.removeFromSuperview() }
        layers[index].removeFromSuperview()
        layers.remove(at: index)
        
        setNeedsLayout()
    }
    
    
    /// Draw line between given two `CGPoint`s in `view`. Line of const width, wider on ends, narrower on the middle.
    ///
    /// - Parameters:
    ///   - startPoint: Start point of line
    ///   - endPoint: End point of line
    ///   - view: View where line will be drawed
    func drawLine(from startPoint: CGPoint, to endPoint: CGPoint, in view: UIView) {
        // Path
        let path = UIBezierPath()
        
        // Calculate new start (bottom left) and end point (bottom right) for curve
        let newStart = CGPoint(x: startPoint.x, y: startPoint.y + 5)
        let newEnd = CGPoint(x: endPoint.x, y: endPoint.y + 5)
        
        // Controll point for curves (middle point betweeb two given as fun parameters points)
        let controlPoint = CGPoint(x: (startPoint.x + endPoint.x) / 2, y: (startPoint.y + endPoint.y) / 2)
        
        path.move(to: newStart)
        // Add bottom curve
        path.addQuadCurve(to: newEnd, controlPoint: controlPoint)
        
        // Calculate new start (top right) and end point (top left) for curve
        let newStart1 = CGPoint(x: startPoint.x, y: startPoint.y - 5)
        let newEnd1 = CGPoint(x: endPoint.x, y: endPoint.y - 5)
        
        path.addLine(to: newEnd1)
        // Add top curve
        path.addQuadCurve(to: newStart1, controlPoint: controlPoint)
        path.addLine(to: newStart)
        
        // Layer
        let shapeLayer = LineShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6).cgColor
        // shadow
        shapeLayer.shadowColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.4).cgColor
        shapeLayer.shadowOpacity = 0.5
        shapeLayer.shadowRadius = 2.0
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        view.layer.insertSublayer(shapeLayer, at: 0)
    }
}


// Just for distinguish lines in all layers
class LineShapeLayer: CAShapeLayer {}


