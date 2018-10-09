//: [Previous](@previous)

import UIKit
import XCPlayground
import PlaygroundSupport

//: # Learning sleeping example

//: ## Overview
/*:
 In this example I will show you more complex example. Our Neural Network should predict what will be the exam score of student. Training set will contains student's:
 * sleeping duration and learing duration in day before exam as an input data,
 * exam score as an output data.
 
 As you can see there are non linear data. One hour of learning and 12 hours of sleeping will not help in get height score as well as 12 hours of learning and 1 hour of sleeping. So you can see that there is hard to say what will be the result of given input data.
 
 We will provide normalized data in belowe structure
 * input:
    * sleeping duration: 0.0 ..< 1.0, 0.0 - 0 hours of sleep, 1.0 - 12 hours of sleep
    * learning duration: 0.0 ..< 1.0, 0.0 - 0 hours of learning, 1.0 - 12 hours of learning
 * output:
    * exam score: 0.0 ..< 1.0, 0.0 - 0 points, 1.0 - 100 points

 The goal of the Neural Network is to predict student exam score based on given information. 
 */

//: ## Configure views

/*:
 Views are created in exactly the same way as in [Basic example](BasicExample)
 */
let view = DefaultBackgroundView(frame: CGRect(x: 0.0, y: 0.0, width: 480.0, height: 600.0))
let neuralNetworkVisualizationView = NeuralNetworkVisualisationView(frame: CGRect(x: 10.0, y: 10.0, width: 460.0, height: 500.0))
let neuralNetworkControlView = NeuralNetworkControlView(frame: CGRect(x: neuralNetworkVisualizationView.frame.minX, y: neuralNetworkVisualizationView.frame.maxY, width: neuralNetworkVisualizationView.frame.width, height: 100.0))

//: ## Configure Neural Network
/*:
 In configuration of Neural Network are some modifications. Our `inputSize` will be `2` - sleeping and learning durations. `outputSize` will be `1` - exam score. Additionally we will create more hidden layers to show more complex Neural Network. There is no rules in matching number an sizes of hidden layers. Each case is unique. In our example, I decide to create 2 hidden layers with 5 and 4 neurons. You can change those values at your discretion.
 */
let neuralNetworkInitParams = NeuralNetworkInitParameters(inputSize: 2, outputSize: 1, hiddenLayersSizes: [5, 4])
let neuralNetwork = NeuralNetwork(with: neuralNetworkInitParams, visualizationView: neuralNetworkVisualizationView)

//: Neural Network Controller is exactly the same like in Basic Example.
let neuralNetworkController = NeuralNetworkController(defaultBackgroundView: view, neuralNetworkControlView: neuralNetworkControlView, neuralNetwork: neuralNetwork, neuralNetworkVisualizationView: neuralNetworkVisualizationView)

PlaygroundPage.current.liveView = view


//: ## Initially train
/*:
 There are some changes in Neural Network training operation. Now we can not train with sigle data multiplied thousends of times - it will not correctly train our Neural Network in this example. We ahve to use training set with much more varius values - higher entropy. In `normalizedTrainingDataSet1`, I prepared normalized data set with several, different data sets. Unfortunatelly, there is still not enough so wi will multiply them by 1k in training operation.
 */
let trainingDataSetMutiplication = 1_000
let inputTestData = [0.8, 0.3]
neuralNetworkController.trainNeuralNetwork(with: normalizedTrainingDataSet1, numberOfTimes: trainingDataSetMutiplication) {
    neuralNetworkController.testNeuralNetwork(with: TrainingData(vectorIn: inputTestData, vectorOut: []))
}


neuralNetworkControlView.trainAgainTouchUpInsideAction = {
    neuralNetworkController.resetNeuralNetwork {
        neuralNetworkController.trainNeuralNetwork(with: normalizedTrainingDataSet1, numberOfTimes: trainingDataSetMutiplication) {
            neuralNetworkController.testNeuralNetwork(with: TrainingData(vectorIn: inputTestData, vectorOut: []))
        }
    }
}


/*:
- Note:
 To see different results and training durations, change training times parameter and hidden layers configuration.
 
 
- Note:
 After changing hidden layers configuration, also Neural Network Visualisation view will change.
 */
