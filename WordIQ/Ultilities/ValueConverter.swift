
class ValueConverter {
    
    static func DoubleToPercent( _ value : Double) -> String {
        return String(format: "%.2f%%", value * 100);
    }
}
