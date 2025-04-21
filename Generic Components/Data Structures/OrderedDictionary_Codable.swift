/// A dictionary that preserves the order in which items were added
struct OrderedDictionaryCodable<Key: Hashable & Codable, Value: Codable>: Codable, Sequence {
    // MARK: - Properties
    private var keys: [Key] = []
    private var values: [Key: Value] = [:]

    /// Returns the last key added to the ordered dictionary
    var lastKey: Key? { keys.last }

    /// Returns the value of the last key added to the ordered dictionary
    var lastValue: Value? {
        guard let lastKey = keys.last else { return nil }
        return values[lastKey]
    }

    /// All keys in their insertion order
    var allKeys: [Key] { keys }

    /// All values in their insertion order
    var allValues: [Value] { keys.compactMap { values[$0] } }

    /// Total count of items in the dictionary
    var count: Int { keys.count }

    // MARK: - Initializers
    init() {}

    // MARK: - Subscript
    subscript(key: Key) -> Value? {
        get { values[key] }
        set {
            if let newValue = newValue {
                if values[key] == nil {
                    keys.append(key)
                }
                values[key] = newValue
            } else {
                keys.removeAll { $0 == key }
                values[key] = nil
            }
        }
    }

    // MARK: - Public Methods
    /// Retrieves the value associated with a key
    func value(forKey key: Key) -> Value? { values[key] }

    /// Clears all data from the dictionary
    mutating func clear() {
        keys = []
        values = [:]
    }

    /// Creates a deep copy of the dictionary
    func copy() -> OrderedDictionaryCodable<Key, Value> {
        var newDictionary = OrderedDictionaryCodable<Key, Value>()
        newDictionary.keys = self.keys
        newDictionary.values = self.values
        return newDictionary
    }

    // MARK: - Codable Conformance
    enum CodingKeys: String, CodingKey {
        case keys
        case values
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keys, forKey: .keys)
        try container.encode(keys.map { values[$0]! }, forKey: .values)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        keys = try container.decode([Key].self, forKey: .keys)
        let decodedValues = try container.decode([Value].self, forKey: .values)

        // Reconstruct the values dictionary
        values = Dictionary(uniqueKeysWithValues: zip(keys, decodedValues))
    }

    // MARK: - Sequence Conformance
    func makeIterator() -> AnyIterator<(Key, Value)> {
        var index = 0
        return AnyIterator {
            guard index < self.keys.count else { return nil }
            let key = self.keys[index]
            index += 1
            return (key, self.values[key]!)
        }
    }
}
