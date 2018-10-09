//: [Previous](@previous)

import UIKit
import XCPlayground
import PlaygroundSupport

//: # Basic example

//: ## Overview
/*:
 In this example I will show you how to configure, train and test Neural Network so that it could predict correct output values based on input ones. To show you how it works I used not very detailed example. This will show you exactly how it works.
 
  - Note:
 More real-live example you can find in [learning/sleeping example](LearningSleepingExample).
 
 In our basic example we will consider case where we have perfect world with only 3 values. Those 3 values always give other constant 3 values.
 * 3 input values: `[3, 4, 5]`,
 * 3 output values: `[0.1, 0.2, 0.3]`.
 
 The goal of the Neural Network is to predict output for given `[3, 4, 5]` input. Every human see what output should be (`[0.1, 0.2, 0.3]`), but for machine, it is not so obvious.
 */

//: ## Preparation of Background View
//: Firstly, we will prepare background view. It will be the view where we will keep all future views.
let view = DefaultBackgroundView(frame: CGRect(x: 0.0, y: 0.0, width: 480.0, height: 600.0))

//: ## Create Neural Network Visualisation View
/*: 
 Secondly, we will create visualisation view for our future Neural Network. That will be view, that will illustrate how many:
 * layers, 
 * neurons in each layer,
 * connections between neurons
 
 our Neural Network consists.
 This view will respond for our changes in Neural Network. It will visualize current, real structure of our Neural Network.
 
 We will place this view on the top of our background view.
 */
let neuralNetworkVisualizationView = NeuralNetworkVisualisationView(frame: CGRect(x: 10.0, y: 10.0, width: 460.0, height: 500.0))

//: ## Create Neural Network Control View
/*: 
 Now, We will create control view which contains Neural Network training duration time, testing result label and "Train again button". This view will be helpful in maintaining Neural Network and also will display basic informations about results.
 
 We will place it right below `NeuralNetworkVisualisationView`.
 */
let neuralNetworkControlView = NeuralNetworkControlView(frame: CGRect(x: neuralNetworkVisualizationView.frame.minX, y: neuralNetworkVisualizationView.frame.maxY, width: neuralNetworkVisualizationView.frame.width, height: 100.0))

//: ## Create neural network instance
/*: 
 Next, we will create and configure our Neural Network. To create Neural Network, firstly, we have to create instance of `NeuralNetworkInitParameters`. It's initialiser has parameters describe size of input layer (number of values-neurons) and size of output layer (number of values-neurons). It also takes array of numbers of neurons in each hidden layer. Let's initialize it with:
 * `inputSize` = `3`
 * `outputSize` = `3`
 * `hiddenLayersSizes` = `[5]`
 
 This set of parameter will describe Neural Network with 3 inputs, 3 outputs and 1 hidden layer with 5 neurons.
 
- Note:
 Neural Network with these parameters will be visualised in `liveView`.
 */
let neuralNetworkInitParams = NeuralNetworkInitParameters(inputSize: 3, outputSize: 3, hiddenLayersSizes: [5])

/*:
 Now, we can create instance of `NeuralNetwork`. It takes in initializer `NeuralNetworkInitParameters` object which we already created previusly and `NeuralNetworkVisualisationView` which we also already have. `NeuralNetworkVisualisationView` is needed to pass informations about layers, neurons and connections to visualisation view.
 
 Initializer will create Neural Network model with desired parameters. It also creates weights matrixes in proper sizes with random generated initial values.
 */
let neuralNetwork = NeuralNetwork(with: neuralNetworkInitParams, visualizationView: neuralNetworkVisualizationView)


//: ## Create Neural Network controller
/*:
 To keep all above views and models, we will use `NeuralNetworkController`. It organises all views, helps in maintaining them, gives us simple API to communicate with Neural Network - train them and test them.
 
 Controller is also responsible for informing you about end of training process - "beep" sound 🔊.
 */
let neuralNetworkController = NeuralNetworkController(defaultBackgroundView: view, neuralNetworkControlView: neuralNetworkControlView, neuralNetwork: neuralNetwork, neuralNetworkVisualizationView: neuralNetworkVisualizationView)

//: ## Set live view
/*:
 Right after create all needed views and structures of that views, we can set most bottom view in our hierarchy as a `liveView`. It will allows us to see, how the structure of Neural Network looks like and what is currently going on with them.
 */
PlaygroundPage.current.liveView = view

//: ## Interaction with Neural Network
//: Finally we can start using our Neural Network 🎉.

//: ### Initially train
/*:
 To give our Neural Network ability for predicting something, firstly, we have to teach it. This process is called "training".
 
 To reach satisficated results, we have to train our Neural Network  with about 5k times with our single input-output data. In normal cases (e.g [learning/sleeping example](LearningSleepingExample)) data sets consists of varoius data (big entropy), not only one multiplicated thousands of times. However, in our case that simplification will be enough.
 
 So, let's train our Neural Network with single data 5k times. Training process is performed asynchronously in background queue so method will inform us about finish of training process in completion handler closure.
 */
neuralNetworkController.trainNeuralNetwork(with: [TrainingData(vectorIn: [3, 4, 5], vectorOut: [0.1, 0.2, 0.3])], numberOfTimes: 5_000) {
    
//: ### Testing Neural Network
/*:
 Great! we have trained Neural Network right now. So we can test it. In test procedure we provide only input data and let Neural Network to calculate output data itself. We expect results very close to `[0.1, 0.2, 0.3]`. If not, we can modify number of hidden layers and its neurons. In our perfect world, in this example, we can increase number of training iterations, however 5_000 training data iterations should be enough. If not, step back to previous line of code and change `5_000` into higher value.
*/
    neuralNetworkController.testNeuralNetwork(with: TrainingData(vectorIn: [3, 4, 5], vectorOut: []))
}

//: ### Train again button
/*:
 Everything's fine, but we can not use "Train again button". To enable this button we have to provide `trainAgainTouchUpInside Action` property of `NeuralNetworkControlView`. "Train again" function allows to reset trained Neural Network, re-train it and test it again.
 */
neuralNetworkControlView.trainAgainTouchUpInsideAction = {
/*: 
 Firstly, we have to reset already trained Neural Network. This method resets all data generated through previous training operation. There is a couple of data calculated in previous training operation, e.g. matrix of weights.
     
 It is an asynchronous method so in its completion handler we provide another method.
 */
    neuralNetworkController.resetNeuralNetwork {

/*:
After reset previous training related data, we train again with the same data set (single input-output data) multiplied 5k times.
 */
        neuralNetworkController.trainNeuralNetwork(with: [TrainingData(vectorIn: [3, 4, 5], vectorOut: [0.1, 0.2, 0.3])], numberOfTimes: 5_000) {

/*:
In training completion closure we test again with our perfect-world input data.
 */
            neuralNetworkController.testNeuralNetwork(with: TrainingData(vectorIn: [3, 4, 5], vectorOut: []))
        }
    }
}
/*:
 `NeuralNetworkControlView` gives us information about training time duration and test results. Thanks to it, we can compare different Neural Network configurations (additional hidden layer etc.). We also can decide if we need additional training data or not.
 */
/*:
 - Note:
 In console you can observe more precise test results.
 */

/*:
 We should keep in mind ,that Neural Network only tends to correct value. It will be as precise as complex(varius, big entropy) data set we provide.
 
 In next example I will show you more real example.
 */

//: [Next](@next)
