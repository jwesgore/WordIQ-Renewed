/// Implementation of a dictionary that preserves the order this were stored in
struct OrderedDictionary<Key: Hashable, Value> : Sequence {
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

/// Extension to add reduction capability
extension OrderedDictionary {
    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, (Key, Value)) -> Result) -> Result {
        keys.reduce(initialResult) { result, key in
            nextPartialResult(result, (key, values[key]!))
        }
    }
}

/// Extension to add mapValues capability
extension OrderedDictionary {
    func mapValues<NewValue>(_ transform: (Value) -> NewValue) -> OrderedDictionary<Key, NewValue> {
        var newOrderedDict = OrderedDictionary<Key, NewValue>()
        
        for key in keys {
            if let value = values[key] {
                newOrderedDict[key] = transform(value)
            }
        }
        
        return newOrderedDict
    }
}

/// Extension to allow OrderedDictionary to be cast to OrderedDictionaryCodable
extension OrderedDictionary {
    func toCodable() ->
    OrderedDictionaryCodable<Key, Value>
    where Key: Codable, Value: Codable {

        var codableDict = OrderedDictionaryCodable<Key, Value>()
        
        for key in keys {
            if let value = values[key] {
                codableDict[key] = value
            }
        }
        
        return codableDict
    }
}
