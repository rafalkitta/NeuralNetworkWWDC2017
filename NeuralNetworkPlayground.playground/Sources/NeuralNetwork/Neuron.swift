import Foundation


/// Neural network neuron structure
public struct Neuron {
    
    // Matrix size
    
    /// Number of `matrix` rows
    public var rows: Int = 0
    
    /// Number of `matrix` columns
    public var columns: Int = 0
    
    /// Matrix: rows x columns
    public var matrix: [[Double]] = [[]]
    
    
    /// Default initializer. Creates empty matrix on given sizes (m x n).
    ///
    /// - parameter rows:         Number of matrix rows
    /// - parameter columns:      Number of matrics colums
    /// - parameter defaultValue: Default value of matrix
    ///
    /// - returns: `Neuron` instance
    public init(rows: Int, columns: Int, defaultValue: Double = 0.0) {
        self.rows = rows
        self.columns = columns
        self.matrix = [[Double]](repeating: [Double](repeating: defaultValue, count: columns), count: rows)
    }
    
    
    /// Populates matrix with random values from range: -5...5
    ///
    /// - Note: mutate `matrix property`
    public mutating func randomizeMatrix() {
        // Iterate through rows
        for i in 0..<matrix.count {
            // Iterate through columns
            for j in 0..<matrix[i].count {
                matrix[i][j] = Double(arc4random_uniform(10)) - 5.0
            }
        }
    }
}


// MARK: - CustomStringConvertible
extension Neuron: CustomStringConvertible {
    
    /// Structure instance description format
    public var description: String {
        return "\nrows: \(rows), colums: \(columns), \(matrix)"
    }
}


