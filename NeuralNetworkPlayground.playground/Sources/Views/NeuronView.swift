import UIKit


/// View represents single neuron
open class NeuronView: UIView {
    
    /// Neuron body bright dot
    var neuronBodyView: UIView = UIView()
    
    /// Constant size of neuron's body
    let neuronBodyViewSize = CGSize(width: 16.0, height: 16.0)
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addNeuronBodyView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addNeuronBodyView()
    }
    
    
    /// Adds neuron's body view
    private func addNeuronBodyView() {
        neuronBodyView.backgroundColor = UIColor(red: 198/255, green: 255/255, blue: 255/255, alpha: 0.93)
        neuronBodyView.layer.shadowColor = UIColor(red: 298/255, green: 255/255, blue: 255/255, alpha: 0.97).cgColor
        neuronBodyView.layer.shadowOpacity = 0.9
        neuronBodyView.layer.shadowRadius = 3.0
        neuronBodyView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        neuronBodyView.layer.cornerRadius = 8.0
        neuronBodyView.clipsToBounds = false
        addSubview(neuronBodyView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // 
        neuronBodyView.frame = CGRect(
            x: frame.width / 2.0 - neuronBodyViewSize.width / 2.0,
            y: frame.height / 2.0 - neuronBodyViewSize.height / 2.0,
            width: neuronBodyViewSize.width,
            height: neuronBodyViewSize.height)
    }
    
}

