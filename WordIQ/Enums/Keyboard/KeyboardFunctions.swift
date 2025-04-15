/// Enum representing all valid keyboard function keys
enum KeyboardFunctions: String, CaseIterable {
    case enter, backspace
    
    /// Return the string representing the associated icon
    var symbol: String {
        switch self {
        case .enter: return SFAssets.enter.rawValue
        case .backspace: return SFAssets.delete.rawValue
        }
    }
    
    /// Parse a string and return the enum value
    static func from(_ string: String) -> KeyboardFunctions? {
        return KeyboardFunctions.allCases.first { $0.rawValue == string }
    }
}
