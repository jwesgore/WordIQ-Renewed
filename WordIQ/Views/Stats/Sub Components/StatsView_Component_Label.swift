import SwiftUI

/// A view component for displaying a labeled value in a horizontal format.
///
/// This component arranges a bold numeric value alongside its label, optionally aligning the content
/// with a spacer for layout flexibility. It is designed for use in stats displays, with emphasis
/// on readability and accessibility.
///
/// Example: `value label`
///
/// - Parameters:
///   - label: The label text describing the value (e.g., "Games Played").
///   - value: The numeric or textual value associated with the label (e.g., "42").
///   - withSpacer: A Boolean value that determines whether a spacer is included to align the content horizontally. Defaults to `true`.
struct StatsView_Component_Label: View {
    
    /// The label text providing context for the value.
    var label: String
    
    /// The numeric or textual value associated with the label.
    var value: String
    
    /// Determines whether a spacer is included for alignment. Defaults to `true`.
    var withSpacer: Bool = true
    
    var body: some View {
        HStack {
            // Include spacer at the beginning if specified.
            if withSpacer {
                Spacer()
            }
            
            // Display the bold value.
            Text(value)
                .fontWeight(.bold)
            
            // Display the label with reduced opacity for visual hierarchy.
            Text(label)
                .opacity(0.5)
        }
        .robotoSlabFont(.title1, .regular) // Applies a custom font styling.
    }
}
