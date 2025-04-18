import Foundation
import SwiftUI

/// A utility class that provides methods for value conversion, including colors, dates, and formatting.
class ValueConverter {
    // MARK: - Hex Color Conversion
    
    /**
     Converts a hex color string to a SwiftUI Color object.
     
     - Parameter hex: The hex string representing a color (e.g., "#FF5733" or "FF5733").
     - Returns: A SwiftUI `Color` object.
     */
    static func colorFromHex(_ hex: String) -> Color {
        var hexNumber: UInt64 = 0
        let scanner = Scanner(string: hex.hasPrefix("#") ? String(hex.dropFirst()) : hex)
        scanner.scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000FF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }

    // MARK: - Date Component Conversion
    
    /**
     Converts a `Date` object to its corresponding `DateComponents`.
     
     - Parameters:
       - date: The `Date` object to be converted.
       - components: The set of calendar components to extract (e.g., `.year`, `.month`, `.day`).
     - Returns: A `DateComponents` object containing the extracted components.
     */
    static func dateToDateComponents(_ date: Date, components: Set<Calendar.Component>) -> DateComponents {
        Calendar.current.dateComponents(components, from: date)
    }
    
    /**
     Converts a `DateComponents` object to a `Date` object.
     
     - Parameter components: The `DateComponents` to be converted.
     - Returns: A `Date` object if the components are valid, or `nil` otherwise.
     */
    static func dateComponentsToDate(_ components: DateComponents) -> Date? {
        Calendar.current.date(from: components)
    }
    
    // MARK: - Days Calculation
    
    /**
     Calculates the number of days elapsed since the provided date.
     
     - Parameter date: The starting `Date`.
     - Returns: The number of days between the starting date and the current date, or `nil` if the calculation fails.
     */
    static func daysSince(_ date: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day
    }

    // MARK: - Formatting Functions
    
    /**
         Converts a `Double` value to a percentage string with two decimal places.
         
     - Parameter value: The `Double` value to be converted (e.g., `0.874` will be converted to `"87.40%"`).
     - Parameter includeSign: A Boolean value indicating whether the percentage sign (`%`) should be included.
     - Returns: A formatted percentage string.
     */
    static func doubleToPercent(_ value: Double, includeSign: Bool = true) -> String {
        if includeSign {
            return String(format: "%.2f%%", value * 100)
        } else {
            return String(format: "%.2f", value * 100)
        }
    }
    
    /**
     Converts a `Double` value to a string with two decimal places.
     
     - Parameter value: The `Double` value to be formatted.
     - Returns: A formatted string (e.g., `0.874` will be converted to `"0.87"`).
     */
    static func doubleToTwoPlaces(_ value: Double) -> String {
        String(format: "%.2f", value)
    }
    
    /**
     Calculates the percentage represented by two integers and formats it as a string.
     
     - Parameters:
       - top: The numerator of the percentage calculation (optional).
       - bottom: The denominator of the percentage calculation (optional).
     - Returns: A formatted percentage string, or `"0.00%"` if the input is invalid or the denominator is zero.
     */
    static func intsToPercent(top: Int?, bottom: Int?) -> String {
        guard let top = top, let bottom = bottom, bottom != 0 else { return "0.00%" }
        return doubleToPercent(Double(top) / Double(bottom))
    }
}
