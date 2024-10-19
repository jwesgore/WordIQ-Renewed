/// Enum representing all valid keyboard function keys
enum KeyboardFunctions: String, CaseIterable {
    case enter
    case backspace
    
    /// Return the string representing the associated icon
    var sfsymbol: String {
        switch self {
        case .enter: return SFAssets.enter
        case .backspace: return SFAssets.delete
        }
    }
    
    /// Parse a string and return the enum value
    static func from(_ string: String) -> KeyboardFunctions? {
        return KeyboardFunctions.allCases.first { $0.rawValue == string }
    }
}
