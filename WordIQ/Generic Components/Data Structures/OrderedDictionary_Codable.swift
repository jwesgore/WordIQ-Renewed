/// Implementation of a dictionary that preserves the order this were stored in
struct OrderedDictionaryCodable<Key: Hashable & Codable, Value: Codable> : Codable, Sequence {
    private var keys: [Key] = []
    private var values: [Key : Value] = [:]
    
    init() {}
    
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
    
    subscript(key: Key) -> Value? {
        get {
            values[key]
        }
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
    
    func value(forKey key: Key) -> Value? {
        values[key]
    }

    // MARK: - Conformance to Codable
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
    
    // MARK: - Conformance to Sequence
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
