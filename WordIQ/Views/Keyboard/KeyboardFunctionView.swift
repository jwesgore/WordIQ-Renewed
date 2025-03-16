import SwiftUI

struct KeyboardFunctionView : View {
    
    @ObservedObject var functionVM : KeyboardFunctionViewModel
    
    init(_ functionVM: KeyboardFunctionViewModel) {
        self.functionVM = functionVM
    }
    
    var body: some View {
        Button {
            Haptics.shared.impact(.medium)
            functionVM.PerformAction()
        } label: {
            Image(systemName: functionVM.keyboardFunction.symbol)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: CGFloat(RobotoSlabOptions.Size.title2), maxHeight: CGFloat(RobotoSlabOptions.Size.title2))
                .foregroundStyle(functionVM.fontColor)
        }
        .frame(width:functionVM.width, height: functionVM.height)
        .background(functionVM.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: functionVM.cornerRadius)
                .stroke(functionVM.borderColor, lineWidth: functionVM.borderThickness)
        )
        .clipShape(RoundedRectangle(cornerRadius: functionVM.cornerRadius))
    }
}
