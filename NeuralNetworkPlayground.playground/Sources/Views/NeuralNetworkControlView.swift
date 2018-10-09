import UIKit


/// View contains Neural Network training duration, test result and train again button
open class NeuralNetworkControlView: UIView {
    
    /// Learning duration title label
    var learningDurationTitleLabel: UILabel
    
    /// Learning duration value label
    open var learningDurationLabel: UILabel
    
    /// Test result title label
    var resultTitleLabel: UILabel
    
    /// Test result value label
    open var resultLabel: UILabel
    
    /// Train again button
    open var trainAgainButton: UIButton
    
    /// Train again button's action performed after `touchUpInside` event
    open var trainAgainTouchUpInsideAction: (() -> ())?
    
    
    override public init(frame: CGRect) {
        learningDurationTitleLabel = UILabel()
        learningDurationLabel = UILabel()
        resultTitleLabel = UILabel()
        resultLabel = UILabel()
        trainAgainButton = UIButton()

        super.init(frame: frame)
        
        initialSetup()
        addSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        learningDurationTitleLabel = UILabel()
        learningDurationLabel = UILabel()
        resultTitleLabel = UILabel()
        resultLabel = UILabel()
        trainAgainButton = UIButton()
        
        super.init(coder: aDecoder)
        
        initialSetup()
        addSubviews()
    }

    
    /// Custom setup, colors, default values
    func initialSetup() {
        backgroundColor = UIColor(red: 24/255, green: 37/255, blue: 109/255, alpha: 1.0)
        
        learningDurationTitleLabel.text = "Learning time: "
        learningDurationTitleLabel.textColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6)
        learningDurationLabel.text = "_.____"
        learningDurationLabel.textColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6)
        resultTitleLabel.text = "Result: "
        resultTitleLabel.textColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6)
        resultLabel.text = "_,____"
        resultLabel.textColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6)
        
        trainAgainButton.setTitle("Train again", for: .normal)
        trainAgainButton.contentEdgeInsets = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 2.0, right: 5.0)
        trainAgainButton.layer.cornerRadius = 4.0
        trainAgainButton.layer.borderWidth = 1.0
        trainAgainButton.layer.borderColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6).cgColor
        trainAgainButton.setTitleColor(UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6), for: .normal)
        trainAgainButton.setTitleColor(UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.15), for: .disabled)
        trainAgainButton.addTarget(self, action: #selector(trainAgainButtonAction(sender:)), for: .touchUpInside)
    }
    
    func addSubviews() {
        addSubview(learningDurationTitleLabel)
        addSubview(learningDurationLabel)
        addSubview(resultTitleLabel)
        addSubview(resultLabel)
        addSubview(trainAgainButton)    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Learning duration labels layout
        learningDurationTitleLabel.frame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 20.0)
        learningDurationTitleLabel.sizeToFit()
        learningDurationLabel.frame = CGRect(x: learningDurationTitleLabel.frame.maxX, y: 10.0, width: 10.0, height: 20.0)
        learningDurationLabel.sizeToFit()
        
        // Train again button layout
        trainAgainButton.sizeToFit()
        let trainAgainButtonSize = trainAgainButton.bounds.size
        trainAgainButton.frame = CGRect(x: frame.maxX - trainAgainButtonSize.width - 20.0, y: 10.0, width: trainAgainButtonSize.width, height: trainAgainButtonSize.height)
        trainAgainButton.center.y = learningDurationTitleLabel.center.y
        
        // Result labels layout
        resultTitleLabel.frame = CGRect(x: 10.0, y: 40.0, width: 10.0, height: 20.0)
        resultTitleLabel.sizeToFit()
        resultLabel.frame = CGRect(x: resultTitleLabel.frame.maxX, y: 40.0, width: 10.0, height: 20.0)
        resultLabel.sizeToFit()
    }
    
    
    /// Enable/diable train again button during training
    ///
    /// - Parameter enabled: Flag
    open func setTrainAgainButton(enabled: Bool) {
        trainAgainButton.isEnabled = enabled
        
        // Change properly color of button's border
        if enabled {
            trainAgainButton.layer.borderColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.6).cgColor
            
        } else {
            trainAgainButton.layer.borderColor = UIColor(red: 176/255, green: 245/255, blue: 255/255, alpha: 0.15).cgColor
        }
    }
    
    
    /// Touch up inside event action of train again button
    ///
    /// - Parameter sender: Tapped button
    func trainAgainButtonAction(sender: UIButton) -> Void {
        trainAgainTouchUpInsideAction?()
    }
}

