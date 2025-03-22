import SwiftUI

/// Settings for using RobotoSlab font
enum RobotoSlabOptions{
    enum Size : CGFloat {
        case title = 33
        case title1 = 27
        case title2 = 21
        case title3 = 19
        case headline = 16
        case subheading = 14
        case footnote = 12
        case caption = 11
        
    }
    
    enum Weight : String {
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

/// Modifier to assist with adding custom font to views
struct RobotoSlabModifier : ViewModifier {
    
    let size : CGFloat
    let weight : String
    
    func body (content : Content) -> some View {
        content
            .font(.custom(weight, fixedSize: size))
    }
}

/// Extension to allow for simple use of modifier
extension View {
    func robotoSlabFont(_ size : RobotoSlabOptions.Size, _ weight : RobotoSlabOptions.Weight) -> some View {
        self.modifier(RobotoSlabModifier(size: size.rawValue, weight: weight.rawValue))
    }
    
    func robotoSlabFont(_ size : CGFloat, _ weight : String) -> some View {
        self.modifier(RobotoSlabModifier(size: size, weight: weight))
    }
}

/// Extension to allow for adding text views together
extension Text {
    func robotoSlabFont(_ textStyle: Font.TextStyle, _ weight: RobotoSlabOptions.Weight) -> Text {
        self.font(.custom(weight.rawValue, size: UIFont.preferredFont(forTextStyle: UIFont.TextStyle(textStyle)).pointSize))
    }
}

/// Bullshit extra extension
extension UIFont.TextStyle {
    init(_ textStyle: Font.TextStyle) {
        switch textStyle {
        case .largeTitle: self = .largeTitle
        case .title: self = .title1
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .footnote: self = .footnote
        case .caption: self = .caption1
        case .caption2: self = .caption2
        @unknown default: self = .body
        }
    }
}
