/// Implementation of a dictionary that holds a default value
struct DefaultDictionary<Key: Hashable, Value> : Sequence {

    private var keys: [Key] = []
    private var values: [Key : Value] = [:]
    private let defaultValue: Value
    
    init(defaultValue: Value) {
        self.defaultValue = defaultValue
    }
    
    // MARK: - Standard functionality
    var allKeys: [Key] {
        keys
    }

    var allValues: [Value] {
        keys.compactMap { values[$0] }
    }
    
    var count: Int {
        keys.count
    }
    
    subscript(key: Key) -> Value {
        get {
            return values[key, default: defaultValue]
        }
        set {
            if !keys.contains(key) {
                keys.append(key)
            }
            values[key] = newValue
        }
    }
    
    func value(forKey key: Key) -> Value? {
        values[key]
    }
    
    mutating func removeValue(forKey key: Key) {
        keys.removeAll { $0 == key }
        values.removeValue(forKey: key)
    }

    mutating func clear() {
        keys.removeAll()
        values.removeAll()
    }
    
    // MARK: - Conformance to Sequence
    func makeIterator() -> AnyIterator<(Key, Value)> {
        var iterator = values.makeIterator()
        return AnyIterator { iterator.next() }
    }
}

extension DefaultDictionary where Value: Comparable {
    /// Returns the key-value pair with the maximum value in the dictionary.
    /// If the dictionary is empty, returns `nil`.
    func getMax() -> (key: Key, value: Value)? {
        guard let maxPair = values.max(by: { $0.value < $1.value }) else {
            return nil
        }
        return maxPair
    }
    
    /// Returns all key-value pairs sorted by value in descending order.
    ///
    /// - Returns: An array of tuples (key, value), sorted by value in descending order.
    func keyValuePairsDescending() -> [(Key, Value)] {
        return values.sorted(by: { $0.value > $1.value })
    }
}

extension DefaultDictionary where Key: Comparable, Value: Numeric {
    /// Returns the sum of all values for keys greater than the specified key.
    ///
    /// - Parameter threshold: The key to compare against.
    /// - Returns: The sum of all values where the associated key is greater than the given `threshold`.
    func getSumValues(forKeysGreaterThan threshold: Key) -> Value {
        return values
            .filter { $0.key > threshold }
            .reduce(0) { $0 + $1.value }
    }
}

extension DefaultDictionary where Value: Numeric {
    /// Returns the sum of all values
    ///
    /// - Returns: The sum of all values
    func getSumValues() -> Value {
        return values.reduce(0) { $0 + $1.value }
    }
}
