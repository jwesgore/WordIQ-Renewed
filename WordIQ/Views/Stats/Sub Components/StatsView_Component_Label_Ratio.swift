import SwiftUI

/// A view that displays a ratio-like label with two labeled values.
///
/// This component arranges two pairs of labels and values side by side in a horizontal layout.
/// The pairs are separated by a colon (`:`) to represent a ratio, with optional spacing using a `Spacer`.
/// It is intended for use in a stats display, emphasizing numeric data with bold formatting.
///
/// Example: `value1 label1 : value2 label2`
///
/// - Parameters:
///   - label1: The label associated with the first value.
///   - value1: The first numeric value displayed in bold.
///   - label2: The label associated with the second value.
///   - value2: The second numeric value displayed in bold.
///   - withSpacer: A Boolean value indicating whether to include a spacer at the start of the view. Defaults to `true`.
struct StatsView_Component_Label_Ratio: View {
    
    /// The label for the first value.
    var label1: String
    
    /// The first numeric value displayed in bold.
    var value1: String
    
    /// The label for the second value.
    var label2: String
    
    /// The second numeric value displayed in bold.
    var value2: String
    
    /// Determines whether a spacer is included at the start of the layout. Defaults to `true`.
    var withSpacer: Bool = true
    
    var body: some View {
        HStack {
            // Optional spacer to align content horizontally.
            if withSpacer {
                Spacer()
            }
            
            // Display the first value and label.
            Text(value1)
                .fontWeight(.bold)
            
            Text(label1)
                .opacity(0.5)
            
            // Separator for the ratio display.
            Text(":")
            
            // Display the second value and label.
            Text(value2)
                .fontWeight(.bold)
            
            Text(label2)
                .opacity(0.5)
        }
        .robotoSlabFont(.title1, .regular) // Custom font applied to the entire view.
    }
}
