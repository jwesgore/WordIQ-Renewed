import SwiftUI

/// Settings for using RobotoSlab font
enum RobotoSlabOptions {
    enum Size: CGFloat {
        case title = 33
        case title1 = 27
        case title2 = 21
        case title3 = 19
        case headline = 16
        case subheading = 14
        case footnote = 12
        case caption = 11
    }
    
    enum Weight: String {
        case regular = "RobotoSlab-Regular"
        case thin = "RobotoSlab-Regular_Thin"
        case extraLight = "RobotoSlab-Regular_ExtraLight"
        case light = "RobotoSlab-Regular_Light"
        case medium = "RobotoSlab-Regular_Medium"
        case semiBold = "RobotoSlab-Regular_SemiBold"
        case bold = "RobotoSlab-Regular_Bold"
        case extraBold = "RobotoSlab-Regular_ExtraBold"
        case black = "RobotoSlab-Regular_Black"
    }
}

/// Modifier for adding custom font to views
struct RobotoSlabModifier: ViewModifier {
    let size: CGFloat
    let weight: String
    
    func body(content: Content) -> some View {
        content
            .font(.custom(weight, fixedSize: size))
    }
}

/// View Extension for RobotoSlab font
extension View {
    func robotoSlabFont(_ size: RobotoSlabOptions.Size, _ weight: RobotoSlabOptions.Weight) -> some View {
        self.modifier(RobotoSlabModifier(size: size.rawValue, weight: weight.rawValue))
    }
    
    func robotoSlabFont(_ size: CGFloat, _ weight: RobotoSlabOptions.Weight) -> some View {
        self.modifier(RobotoSlabModifier(size: size, weight: weight.rawValue))
    }
}

/// Text Extension for RobotoSlab font
extension Text {
    func robotoSlabFont(_ textStyle: Font.TextStyle, _ weight: RobotoSlabOptions.Weight) -> Text {
        self.font(.custom(weight.rawValue, fixedSize: UIFont.preferredFont(forTextStyle: textStyle.uiFontStyle()).pointSize))
    }
}

/// Font.TextStyle extension to map to UIFont.TextStyle
extension Font.TextStyle {
    func uiFontStyle() -> UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
    }
}
