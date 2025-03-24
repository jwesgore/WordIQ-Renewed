import Foundation
import SwiftUI

class ValueConverter {
    
    static func colorFromHex(_ hex: String) -> Color {
        let scanner = Scanner(string: hex)
        var hexNumber : UInt64 = 0
        
        if (hex.hasPrefix("#")) {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        scanner.scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000F) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
    
    static func dateToDateComponents(_ date: Date, components: Set<Calendar.Component>) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents(components, from: date)
    }
    
    static func dateComponentsToDate(_ dateComponents: DateComponents) -> Date? {
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
    
    static func daysSince(_ date: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateComponents = calendar.dateComponents([.day], from: date, to: currentDate)
        return dateComponents.day
    }
    
    static func doubleToPercent(_ value : Double) -> String {
        return String(format: "%.2f%%", value * 100);
    }
    
    static func doubleToTwoPlaces(_ value : Double) -> String {
        return String(format: "%.2f", value);
    }
    
    static func intsToPercent(top : Int?, bottom: Int?) -> String {
        if let top = top, let bottom = bottom {
            let value : Double = Double(top) / Double(bottom);
            return doubleToPercent(value);
        }
        return "0.00%";
    }
}
