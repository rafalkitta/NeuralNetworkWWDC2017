import UIKit


/// Default background view used in examples
open class DefaultBackgroundView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    // Custom setup
    func initialSetup() {
        backgroundColor = UIColor(red: 24/255, green: 37/255, blue: 109/255, alpha: 1.0)
        layer.borderWidth = 5.0
        layer.borderColor = UIColor.darkGray.cgColor
    }
}
