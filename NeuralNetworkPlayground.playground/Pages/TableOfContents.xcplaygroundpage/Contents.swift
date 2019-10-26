
/*:
 # Table of Contents
 
 * Overview
 * [Basic example](BasicExample)
 * [Learning/sleeping example](LearningSleepingExample)
 */

//: # Overview
/*:
 This Playground was created specially for WWDC 2017 Scholarship by Rafał Kitta. It aims to present fully functional, multidimensional, feed-forwarded Neural Network implementation as a method of machine learning.
 
 It aims to help understanding  machine learning on the example of use Neural Network. There are two examples illustrates working of Neural Network:
 * [Basic example](BasicExample) - simpler one, operates on unreal case, just for showing how this Playground works, what is consist of and what operations every Neural Network performs.
 * [Learning/sleeping example](LearningSleepingExample) - more complex, shows real-world case and how Neural Network can solve not obvious problem.
 
 ## Neural Network implementation
 Presented in Playground, Neural Network was created specially for WWDC 2017 Scholarship. It's implementation was main purpose and main difficulty of this application. As you can see in source code, there is an focus on modularity, clarity of implementation. It was build on the most general abstraction level to allow adaptation Neural Network to any cases.
 
 Neural Network is not trivial machine learning method. Implementation isn not easy but gives very powerful solution. Created implementation is an **multidimensional**, **feed-forwarded** Neural Network. Learning is based on **back-propagation** algorithm where each neuron locally decreases their error using *gradient descend* method. As an activation function, there is used **sigmoidal function**.
 
 ## Neural network visualisation
 To visualize multidimensional Neural Network I have created custom view. It contains various number of Neural Network's layers, and each layer contains various number of neurons. It distributes Neural Network layers equally. Also each Neural Network layer distributes their neurons equally. There is manual layouting. Neurons connections are drawn using Bezier Path curves. Connections simulates natural extensibility (ability to be stretchy) - as long as narrower in the middle. After finishing of Neural Network training process Playground plays "beep" sound. Each change of Neural Network parameters, changes visualisation view.

 
 ## Technologies
 UIKit, AVFoundation, CoreAnimation, Bezier Paths.
  */

//: [Next](@next)
