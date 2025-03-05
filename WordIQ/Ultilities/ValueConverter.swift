
class ValueConverter {
    
    static func DoubleToPercent(_ value : Double) -> String {
        return String(format: "%.2f%%", value * 100);
    }
    
    static func DoubleToTwoPlaces(_ value : Double) -> String {
        return String(format: "%.2f", value);
    }
    
    static func IntsToPercent(top : Int?, bottom: Int?) -> String {
        if let top = top, let bottom = bottom {
            let value : Double = Double(top) / Double(bottom);
            return DoubleToPercent(value);
        }
        return "0.00%";
    }
}
