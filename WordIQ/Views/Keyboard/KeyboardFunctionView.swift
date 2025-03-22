import SwiftUI

struct KeyboardFunctionView : View {
    
    @ObservedObject var functionVM : KeyboardFunctionViewModel
    
    init(_ functionVM: KeyboardFunctionViewModel) {
        self.functionVM = functionVM
    }
    
    var body: some View {
        Button {
            HapticsHelper.shared.impact(.medium)
            functionVM.PerformAction()
        } label: {
            Image(systemName: functionVM.keyboardFunction.symbol)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: RobotoSlabOptions.Size.title2.rawValue, maxHeight: RobotoSlabOptions.Size.title2.rawValue)
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
