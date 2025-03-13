/// Enum to support which characters are considered valid
enum ValidCharacters: Character, CaseIterable, Codable {
    case A = "A", B = "B", C = "C", D = "D", E = "E", F = "F", G = "G"
    case H = "H", I = "I", J = "J", K = "K", L = "L", M = "M", N = "N"
    case O = "O", P = "P", Q = "Q", R = "R", S = "S", T = "T", U = "U"
    case V = "V", W = "W", X = "X", Y = "Y", Z = "Z"
    
    /// Return a String version of the enum
    var stringValue: String {
        return String(self.rawValue)
    }
    
    /// Parse a Character and return the enum value
    static func from(_ character: Character) -> ValidCharacters? {
        let characterUppercased = Character(character.uppercased())
        return ValidCharacters.allCases.first { $0.rawValue == characterUppercased }
    }
    
    /// Parse a String and return the enum value
    static func from(_ string: String) -> ValidCharacters? {
        guard string.count == 1 else { return nil }
        return self.from(Character(string))
    }
}
