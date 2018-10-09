import UIKit
import AVFoundation


/// Class contains all needed structures, models and views of Neural Network. Provides nice API for maintaining Neural Network.
open class NeuralNetworkController {
    
    /// Background view, contains all Neural Network related views as subviews
    open var backgroundView: DefaultBackgroundView
    
    /// Control view
    open var neuralNetworkControlView: NeuralNetworkControlView
    
    /// Neural Network visualisation view
    open var neuralNetworkVisualizationView: NeuralNetworkVisualisationView
    
    /// Neural Network instance
    open var neuralNetwork: NeuralNetwork
    
    // Plays "beep" sound afetr end of training process
    var audioPlayer: AVAudioPlayer!

    
    /// Default initializer of `NeuralNetworkController`
    ///
    /// - Parameters:
    ///   - defaultBackgroundView: background view
    ///   - neuralNetworkControlView: control view
    ///   - neuralNetwork: newurla network
    ///   - neuralNetworkVisualizationView: visualisation view
    public init(defaultBackgroundView: DefaultBackgroundView, neuralNetworkControlView: NeuralNetworkControlView, neuralNetwork: NeuralNetwork, neuralNetworkVisualizationView: NeuralNetworkVisualisationView) {
        
        self.backgroundView = defaultBackgroundView
        self.neuralNetworkControlView = neuralNetworkControlView
        self.neuralNetwork = neuralNetwork
        self.neuralNetworkVisualizationView = neuralNetworkVisualizationView
        
        setupSubviews()
        setupAudioPlayer()
    }
    
    
    /// Setup subviews structure
    func setupSubviews() {
        backgroundView.addSubview(neuralNetworkVisualizationView)
        backgroundView.addSubview(neuralNetworkControlView)
    }
    
    /// Setup audio player for "beep" signal
    func setupAudioPlayer() {
        let path = Bundle.main.path(forResource: "beep", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            audioPlayer = sound
            
        } catch {
            print("Couldn't find sound file, file name: beep.wav")
        }
    }
    
    
    /// Reset Neural Network. Required before next training. Performed asynchronously.
    ///
    /// - Parameter completion: Completion handler
    open func resetNeuralNetwork(completion: @escaping () -> ()) -> Void {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.neuralNetwork.reset()
            completion()
        }
    }
    
    
    /// Train Neural Network. Reset Neural Network befor call this function. Performed asynchronously.
    ///
    /// - Parameters:
    ///   - normalizedDataSet: Normalized training data set
    ///   - times: Number of training times. Default 500. If not enough data set this parameter > 1
    ///   - completion: Completion handler
    open func trainNeuralNetwork(with normalizedDataSet: [TrainingData], numberOfTimes times: Int = 500, completion: @escaping () -> ()) -> Void {
        // Update control view
        DispatchQueue.main.async {
            self.neuralNetworkControlView.learningDurationLabel.text = "_.____"
            self.neuralNetworkControlView.resultLabel.text = "_,____"
            self.neuralNetworkControlView.setTrainAgainButton(enabled: false)
            
            self.neuralNetworkControlView.setNeedsLayout()
        }
        
        // Perform async
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let startDate = Date()
            // training
            self.neuralNetwork.train(with: normalizedDataSet, times: times)
            let endDate = Date()
            
            // Update control view
            DispatchQueue.main.async {
                self.neuralNetworkControlView.learningDurationLabel.text = String(format: "%.4f s", endDate.timeIntervalSince(startDate))
                self.neuralNetworkControlView.setTrainAgainButton(enabled: true)
                self.neuralNetworkControlView.setNeedsLayout()
                // Play "beep"
                self.audioPlayer.play()
            }
            
            completion()
        }
    }
    
    /// Test Neural Network
    ///
    /// - Parameter testData: Test data
    open func testNeuralNetwork(with testData: TrainingData) -> Void {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let result = self.neuralNetwork.propagate(trainingData: testData)
            
            // Update control view
            DispatchQueue.main.async {
                let resultsArray = result.map { String(format: "%.4f", $0) }
                self.neuralNetworkControlView.resultLabel.text = "[\(resultsArray.joined(separator: ", "))]"
                self.neuralNetworkControlView.setNeedsLayout()
            }
            
            // Print to console high precision result
            print("Testing neural network raw result: \(result)")
        }
        
    }
    
}
